#!/bin/bash

# Start all ISPs
docker compose --profile all-isps up -d > /dev/null 2>&1

# Connect to a router for the user to see something happening
docker exec -it atg-bos-bdr-01 bash -c "echo ''; echo
echo '🚀 Connected to ATG BOS BDR-01 Router!'; echo '';"