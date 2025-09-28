## 🌐 Docker Internet Emulator

Inter-domain routing emulation with FRR, Docker Compose, and ipvlan networks.

### ✨ Highlights

- **Composable topology** – `docker-compose.yml` includes per-AS bundles that extend shared router templates.
- **Reusable FRR image** – border and interior routers share an Ubuntu + FRR 8 base image with helper entrypoints.
- **Deterministic interfaces** – ipvlan networks and explicit `interface_name` assignments keep link naming consistent across runs.


### ⚠️ Caution
- **Linux only** – Requires Docker Engine with Compose V2 on a Linux host due to ipvlan networking.
- **Not for production** – This is a learning and experimentation tool, not a production-grade system.
- **Added capabilities** – Containers run with `CAP_NET_ADMIN` and `CAP_NET_RAW` to manipulate networking. 


### 📋 Overview

This project aims to emulate the Internet (or at least, a handful of ISPs, transit providers, CDNs, etc) using FRRouting within Docker containers. In that way, we're running "real" routing software (BGP, OSPF) without the need for specialized hardware or awkward network simulators.

Each Autonomous System is defined within its own Compose file. Border routers, core routers, servers, etc, are all grouped together. Each AS compose file extends shared templates. 

### 🤖 Current Autonomous Systems

#### StrataLink Telecom – AS65222

- IPv4: 172.40.64.0/20
- IPv6: 2001:db8:beef::/40

StrataLink Telecom is a regional ISP based in the Northeastern United States servicing residential, business, and wholesale customers. Currently their sole upstream provider is Axiom Global Transit.

#### Axiom Global Transit – AS65801

- IPv4: 100.100.100.0/18
- IPv6: 2001:db8:101::/36

Axiom Global Transit is a mid-sized Tier 2 transit provider with a global footprint. They peer with several Tier 1 networks and operate multiple data centers worldwide.


### 🤝 Current Peering Arrangements

- **StrataLink Telecom (AS65222)** <--> **Axiom Global Transit (AS65801)**
  - Bilateral agreement
  - Transit Subnets:
    - IPv4 100.100.101.0/30


### 🧩 Compose building blocks

```
docker-compose.yml
├─ router-templates.yml        # Canonical definitions for border/interior routers
├─ AS-65222-SLT.yml            # StrataLink Telecom (AS65222) topology (border + core)
└─ AS-65801-AGT.yml            # Axiom Global Transit (AS65801) topology (border)
```

- `router-templates.yml` declares template services for `border-router` and `interior-router`. Both mount the `scripts/` directory read-only and start via role-specific entrypoints.
- Each AS file supplies hostnames, container names, environment variables, and binds docker networks to `eth0`/`eth1` as needed.
- Compose profiles (`all-isps`, `slt-as`, `agt-as`) let you launch the full lab or focus on a single autonomous system.


### 🚀 Getting started

1. **Prerequisites** – Docker Engine with the Compose V2 plugin on Linux.
2. **Build and launch everything**
   ```bash
   docker compose --profile all-isps up --build
   ```
3. **Check status**
   ```bash
   docker compose --profile all-isps ps
   ```
4. **Run a single AS profile**
   ```bash
   docker compose --profile slt-as up
   docker compose --profile agt-as up
   ```
5. **Stop and clean up**
   ```bash
   docker compose --profile all-isps down
   ```

### 🔧 Router bootstrap sequence

Both entrypoint scripts (`entrypoint-border.sh`, `entrypoint-interior.sh`) perform the following steps:

1. Print a banner indicating the ISP and ASN being configured.
2. Copy the appropriate `daemons` template for the router role into `/etc/frr/daemons`.
3. Copy `scripts/frr-${HOSTNAME}.conf` into `/etc/frr/frr.conf`.
4. Enable IPv4 forwarding (`sysctl -w net.ipv4.ip_forward=1`). Border routers also flush docker-assigned IPv4 addresses from each interface.
5. Start the FRR service via `/etc/init.d/frr start` and keep the container running with `sleep infinity`.

### 🧪 Validation checklist

- **BGP adjacency**
  ```bash
  docker exec -it <container_name> vtysh -c "show ip bgp summary"
  ```
- **Route tables**
  ```bash
  docker exec -it <container_name> vtysh -c "show ip bgp"
  ```
- **Reachability Examples**
  ```bash
  docker exec -it slt-mht-bdr-01 ping -I 172.40.64.1 100.100.101.1
  docker exec -it agt-bos-bdr-01 ping -I 100.100.100.1 172.40.64.1
  ```

Sample BGP output (StrataLink border):

```
   Network          Next Hop            Metric LocPrf Weight Path
*> 100.100.100.0/18 100.100.101.1            0             0 65801 i
*> 172.40.64.0/20   0.0.0.0                  0         32768 i
```

### 📜 Conventions & Standards 
- Autonomous systems use private ASNs from the 64k-65k range (e.g., 65222, 65801).
- IPv4 addressing uses RFC 1918 space (e.g., 172.40.0.0/20, 100.100.100.0/18).
- IPv6 addressing uses documentation prefixes (e.g., 2001:db8::/32).
- Router names use IATA airport codes for border routers (e.g., `slt-mht-bdr-01` for StrataLink's Manchester, NH border router) and simple numeric names for core routers (e.g., `slt-core-01`).
- Transit subnets between ASNs use /30 for IPv4 and /126 for IPv6 point-to-point links. The subnets are typically provided by the upstream AS.

### ➕ Adding new Autonomous Systems
To add a new Autonomous System, follow these steps:
1. **Create a new Compose file** – e.g., `AS-12345-NEW.yml` for the new AS. 
2. **Extend router templates** – Use the `border-router` and `interior-router` templates from `router-templates.yml`. Entrypoints and volume mounts are inherited.
3. **Define networks and link** - Each point-to-point link should have its own ipvalan network defined in the new AS compose file. Typically, the AS providing the transit subnets will have the networks defined in their compose file. 
4. **Connect Interfaces** - Under the service definition for each router, connect the appropriate networks to `eth0`, `eth1`, using `interface_name` to ensure deterministic naming.
5. **Create a FRR config** – Add a corresponding `frr-<hostname>.conf` file in the `scripts/` directory with the necessary BGP/OSPF configuration for each router. IP addresses are assigned within the config file, not by Docker.
6. **Update the main compose file** – Add the new AS compose file to `docker-compose.yml` and create a new profile if desired.

### 🐞 Troubleshooting tips

- `docker logs <container>` captures entrypoint output (useful for copy or permission issues).
- `docker exec -it <container> vtysh -c "show logging"` surfaces FRR debug logs without leaving the CLI.
- Confirm ipvlan networks with `docker network ls`; each point-to-point link is defined in the AS-specific YAML files.
- If Compose warns about unknown profiles, upgrade to Compose v2.17+.

### 🧭 Next steps

- Add IPv6 advertisements (`2001:db8:beef::/40`, `2001:db8:101::/36`).
- Use `customer-templates.yml` as a starting point for customer edge routers.
- Layer on telemetry or alerting (e.g., [BGPalerter](https://github.com/nttgin/BGPalerter)).
- Introduce service nodes (DNS, web) behind StrataLink to test policy routing.
- Experiment with route filtering, prepending, and MEDs between the two ASNs.
- Introduce a CDN (or eyeball network similar to Netflix) to begin experimenting with IP anycast, partial routing, etc.