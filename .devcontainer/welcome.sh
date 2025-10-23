#!/bin/bash

# Display welcome message on first terminal open
if [ ! -f /tmp/.welcome_shown ]; then
    touch /tmp/.welcome_shown
    
    echo ""
    echo "🌐 Welcome to Internet Emulator!"
    echo ""
    
    # Check if containers are running
    if docker compose ps --quiet > /dev/null 2>&1; then
        RUNNING=$(docker compose ps --status running --quiet 2>/dev/null | wc -l)
        if [ "$RUNNING" -gt 0 ]; then
            echo "✅ Routers are running ($RUNNING containers)"
        else
            echo "⏳ Routers are starting..."
        fi
    else
        echo "⏳ Routers are starting..."
    fi
    
    echo ""
    echo "📋 Quick Commands:"
    echo "  docker compose logs -f                # View logs"
    echo "  docker exec -it atg-bos-bdr-01 bash  # Access router"
    echo "  docker exec -it atg-bos-bdr-01 vtysh # FRR CLI"
    echo "  docker compose down                   # Stop all"
    echo ""
fi
