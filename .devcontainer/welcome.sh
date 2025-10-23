#!/bin/bash

# Display welcome message and auto-start on first terminal open
if [ ! -f /tmp/.welcome_shown ]; then
    touch /tmp/.welcome_shown
    
    echo ""
    echo "🌐 Internet Emulator - Starting..."
    echo ""
    
    # Start all routers
    docker compose --profile all-isps up -d
    
    echo ""
    echo "✅ All routers started!"
    echo "🚀 Connecting you to atg-bos-bdr-01..."
    echo ""
    sleep 2
    
    # Drop user into the router with a nice welcome message
    docker exec -it atg-bos-bdr-01 bash -c "cat /workspaces/InternetEmulator/.devcontainer/router-motd.sh && exec bash"
    exit
fi
