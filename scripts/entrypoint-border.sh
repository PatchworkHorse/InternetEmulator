#!/bin/bash

echo "Starting configuration of virtual ISP ${ISP_NAME} (AS${ASN})"

# Replace container daemons file with our template
cp /scripts/daemons-template-border /etc/frr/daemons

# Copy in our custom FRR config
cp /scripts/frr-${HOSTNAME}.conf /etc/frr/frr.conf

# Enable IP forwarding at the kernel level
sysctl -w net.ipv4.ip_forward=1

# Start FRR
/etc/init.d/frr start

# Keepalive
sleep infinity