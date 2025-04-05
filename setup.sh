#!/bin/bash

# WhatsApp MCP Server Setup Script

# Detect operating system
OS="$(uname -s)"

# Prerequisite check and installation
install_prerequisites() {
    echo "Checking and installing prerequisites..."
    
    case "$OS" in
        Darwin)  # macOS
            # Install Homebrew if not exists
            if ! command -v brew &> /dev/null; then
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            fi
            
            # Install Go
            brew install go
            
            # Install Python
            brew install python
            
            # Install UV
            curl -LsSf https://astral.sh/uv/install.sh | sh
            ;;
        
        Linux)  # Assume Ubuntu/Debian
            sudo apt-get update
            
            # Install Go
            sudo add-apt-repository ppa:longsleep/golang-backports
            sudo apt-get update
            sudo apt-get install -y golang
            
            # Install Python
            sudo apt-get install -y python3 python3-pip
            
            # Install UV
            curl -LsSf https://astral.sh/uv/install.sh | sh
            ;;
        
        *)
            echo "Unsupported operating system. Please install prerequisites manually."
            exit 1
            ;;
    esac
}

# Clone WhatsApp MCP repository
clone_repository() {
    echo "Cloning WhatsApp MCP repository..."
    git clone https://github.com/lharries/whatsapp-mcp.git
    cd whatsapp-mcp
}

# Build WhatsApp bridge
build_whatsapp_bridge() {
    echo "Building WhatsApp bridge..."
    cd whatsapp-bridge
    go build
    echo "WhatsApp bridge built successfully."
}

# Configure MCP server
configure_mcp_server() {
    echo "Configuring MCP server..."
    
    # Determine configuration path based on OS
    if [[ "$OS" == "Darwin" ]]; then
        CONFIG_PATH=~/Library/Application\ Support/Claude/claude_desktop_config.json
    else
        CONFIG_PATH=~/.cursor/mcp.json
    fi
    
    # Create configuration directory if it doesn't exist
    mkdir -p "$(dirname "$CONFIG_PATH")"
    
    # Generate configuration
    cat > "$CONFIG_PATH" << EOL
{
  "mcpServers": {
    "whatsapp": {
      "command": "uv",
      "args": [
        "run",
        "$(pwd)/whatsapp-mcp-server/main.py"
      ]
    }
  }
}
EOL
    
    echo "MCP server configuration created at $CONFIG_PATH"
}

# Main setup function
main() {
    # Install prerequisites
    install_prerequisites
    
    # Clone repository
    clone_repository
    
    # Build WhatsApp bridge
    build_whatsapp_bridge
    
    # Configure MCP server
    configure_mcp_server
    
    echo "WhatsApp MCP server setup complete!"
    echo "Next steps:"
    echo "1. Run the WhatsApp bridge in the 'whatsapp-bridge' directory"
    echo "2. Scan the QR code with your WhatsApp mobile app"
    echo "3. Restart Claude Desktop or Cursor"
}

# Run the setup
main
