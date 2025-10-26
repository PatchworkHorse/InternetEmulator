# IP Address Plan

## AS-65801 - Axiom Global Transit (ATG)
**Network Block:** `100.100.0.0/18`

| Router | Interface | IP Address | Description | Connected To |
|--------|-----------|------------|-------------|--------------|
| **atg-bos-bdr-01** | lo | 100.100.0.1/32 | Loopback | - |
| | eth0 | 100.100.1.1/30 | Internal backhaul BOS ↔ NYC | atg-nyc-bdr-01 |
| | eth1 | 100.100.3.1/30 | Peering to StrataLink | slt-mht-bdr-01 |
| **atg-nyc-bdr-01** | lo | 100.100.2.1/32 | Loopback | - |
| | eth0 | 198.51.100.16/24 | IX fabric connection | CNX Route Server |
| | eth1 | 100.100.1.2/30 | Internal backhaul NYC ↔ BOS | atg-bos-bdr-01 |

## AS-65222 - StrataLink Telecom (SLT)
**Network Block:** `172.40.64.0/20`

| Router | Interface | IP Address | Description | Connected To |
|--------|-----------|------------|-------------|--------------|
| **slt-mht-bdr-01** | lo | 172.40.64.1/32 | Loopback | - |
| | eth0 | 100.100.3.2/30 | Peering to ATG | atg-bos-bdr-01 |
| | eth1 | 172.40.64.16/30 | Backhaul to SLT Core | slt-mht-cor-01 |
| **slt-mht-cor-01** | lo | 172.40.64.2/32 | Loopback | - |
| | eth0 | 172.40.64.17/30 | Backhaul to SLT Border | slt-mht-bdr-01 |

## AS-65500 - Core Nexus Exchange (CNX)
**Network Block:** `198.51.100.0/23`

| Router | Interface | IP Address | Description | Connected To |
|--------|-----------|------------|-------------|--------------|
| **cnx-nyc-rs-01** | lo | 198.51.100.1/32 | Loopback | - |
| | eth0 | 198.51.100.2/24 | IX fabric (NYC) | IX Fabric |

## Point-to-Point Links

| Link Description | Network | Router A | IP A | Router B | IP B |
|------------------|---------|----------|------|----------|------|
| ATG Internal (BOS ↔ NYC) | 100.100.1.0/30 | atg-bos-bdr-01 | 100.100.1.1 | atg-nyc-bdr-01 | 100.100.1.2 |
| ATG ↔ SLT Peering | 100.100.3.0/30 | atg-bos-bdr-01 | 100.100.3.1 | slt-mht-bdr-01 | 100.100.3.2 |
| SLT Internal (MHT) | 172.40.64.16/30 | slt-mht-bdr-01 | 172.40.64.16 | slt-mht-cor-01 | 172.40.64.17 |

## Internet Exchange Fabric

| IXP | Network | Location | Members |
|-----|---------|----------|---------|
| Core Nexus Exchange | 198.51.100.0/24 | NYC | atg-nyc-bdr-01 (198.51.100.16), cnx-nyc-rs-01 (198.51.100.2) |

## BGP Summary

| Router | ASN | BGP Router ID | Peers |
|--------|-----|---------------|-------|
| atg-bos-bdr-01 | 65801 | 100.100.0.1 | slt-mht-bdr-01 (eBGP), atg-nyc-bdr-01 (iBGP) |
| atg-nyc-bdr-01 | 65801 | 100.100.2.1 | atg-bos-bdr-01 (iBGP), cnx-nyc-rs-01 (eBGP) |
| slt-mht-bdr-01 | 65222 | 172.40.64.1 | atg-bos-bdr-01 (eBGP) |
| slt-mht-cor-01 | 65222 | 172.40.64.2 | N/A (OSPF only) |
| cnx-nyc-rs-01 | 65500 | 198.51.100.1 | atg-nyc-bdr-01 (eBGP, route-server) |

## Routing Protocols

| AS | IGP | EGP |
|----|-----|-----|
| AS-65801 (ATG) | OSPF Area 0 | BGP |
| AS-65222 (SLT) | OSPF Area 0 | BGP |
| AS-65500 (CNX) | None | BGP (Route Server) |
