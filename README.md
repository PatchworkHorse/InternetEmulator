# Routing Experiments

Learning and experimentation with routing FRR using Docker. 

## Overview

For now, we have a two node setup, each running in its own Docker container.

### Horse ISP (AS100)

- Public IPv4 Space: `216.177.0.0/16` (`216.177.0.0 -> 216.177.255.255`)

### Duck ISP (AS200)

- Public IPv4 Space: `50.50.0.0/16` (`50.50.0.0 -> 50.50.255.255`)

### Ram ISP (AS300) (Not yet connected)

- Public IPv4 Space: `66.211.0.0/16` (`66.211.0.0 -> 66.211.255.255`)

### Peering
- Horse ISP (AS100) <--> Duck ISP (AS200) via a private link using the private IP space `172.31.0.0/24`