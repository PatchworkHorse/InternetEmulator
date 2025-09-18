#!/bin/bash

echo "Starting configuration of virtual border router ${ISP_NAME} (AS${ASN})"

# Replace container daemons file with our template
cp /scripts/daemons-template-border /etc/frr/daemons

# Copy in our custom FRR config
cp /scripts/frr-${HOSTNAME}.conf /etc/frr/frr.conf

# Enable IP forwarding at the kernel level
sysctl -w net.ipv4.ip_forward=1

# Get rid of the Docker-assigned IP addresses; let FRR handle it
for iface in $(ls /sys/class/net/ | grep -v lo); do
    ip addr flush dev $iface
done

# Start FRR
/etc/init.d/frr start

# Keepalive
sleep infinity