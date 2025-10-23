#!/bin/bash

echo "🌐 Starting Internet Emulator..."
docker compose --profile all-isps up -d

echo ""
echo "✅ All routers are starting!"
echo ""
echo "📋 Quick Commands:"
echo "  docker compose logs -f                # View logs"
echo "  docker exec -it atg-bos-bdr-01 bash  # Access router atg-bos-bdr-01"
echo "  docker exec -it atg-nyc-bdr-01 bash  # Access router atg-nyc-bdr-01"
echo "  docker compose down                   # Stop all"
echo ""
