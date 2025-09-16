#!/bin/bash

echo "Starting configuration of virtual ISP ${ISP_NAME} (AS${ASN})"

# Replace container daemons file with our template
cp /scripts/daemons-template /etc/frr/daemons

# Start FRR
/etc/init.d/frr start

# Configure base BGP settings
echo "Configuring base BGP settings for ${ISP_NAME}"
vtysh -c "configure terminal" \
      -c "router bgp ${ASN}" \
      -c " bgp router-id ${BGP_ROUTER_ID}" \
      -c " no bgp default ipv4-unicast" \
      -c " address-family ipv4 unicast" \
      -c "  network 216.177.0.0/16" \
      -c "  redistribute static"

# Configure peers
echo "Configuring BGP peers"
vtysh -c "configure terminal" \
      -c "router bgp ${ASN}" \
      -c " neighbor 172.31.0.3 remote-as 200" \
      -c " neighbor 172.31.0.3 description Duck-ISP"

# Add static route for advertised prefix
vtysh -c "configure terminal" -c "ip route 216.177.0.0/16 Null0"

# Activate neighbor for IPv4 unicast
vtysh -c "configure terminal" \
      -c "router bgp ${ASN}" \
      -c " address-family ipv4 unicast" \
      -c "  neighbor 172.31.0.3 activate"

# Save configuration
vtysh -c "write memory"

# Keepalive
sleep infinity
