#!/bin/bash

echo "Starting configuration of virtual border router ${ISP_NAME} (AS${ASN})"

# Replace container daemons file with our template
cp /scripts/daemons-template-border /etc/frr/daemons

# Copy in our custom FRR config
cp /scripts/frr-${HOSTNAME}.conf /etc/frr/frr.conf

# Enable IP forwarding at the kernel level
sysctl -w net.ipv4.ip_forward=1

# Remove only Docker-assigned IP addresses while preserving interface state
for iface in $(ls /sys/class/net/ | grep -v lo); do
    # Remove IPv4 addresses but keep the interface up and preserve MAC
    ip -4 addr flush dev $iface
done

# Start FRR
/etc/init.d/frr start

# Keepalive
sleep infinity