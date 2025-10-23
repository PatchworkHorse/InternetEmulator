#!/bin/bash

cat << 'EOF'

╔══════════════════════════════════════════════════════════╗
║  🌐 Internet Emulator - Router Terminal                 ║
║  Router: atg-bos-bdr-01 (Axiom Global Transit)          ║
╚══════════════════════════════════════════════════════════╝

📋 Quick Commands:
  vtysh                        # Enter FRR routing CLI
  ip addr                      # Show interfaces
  ping <ip>                    # Test connectivity
  exit                         # Return to Codespace

🔗 Connected Routers:
  • atg-nyc-bdr-01 (100.100.1.2)
  • slt-mht-bdr-01 (100.100.3.2)

💡 Tip: Run 'vtysh' then 'show ip bgp summary' to see BGP peers

EOF
