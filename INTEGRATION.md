# WhatsApp MCP Server Integration

## Prerequisites
- Go (1.16+)
- Python 3.6+
- Git
- WhatsApp mobile app

## Installation Steps

1. Clone the repository
```bash
git clone https://github.com/lharries/whatsapp-mcp.git
cd whatsapp-mcp
```

2. Set up WhatsApp Bridge
```bash
cd whatsapp-bridge
go build
./whatsapp-bridge
```
- First run will generate a QR code
- Scan QR code with WhatsApp mobile app to authenticate

3. Configure MCP Server Connection

### For Claude Desktop
Create/Update `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "whatsapp": {
      "command": "uv",
      "args": [
        "run",
        "{{FULL_PATH_TO}}/whatsapp-mcp-server/main.py"
      ]
    }
  }
}
```

### For Cursor
Create/Update `~/.cursor/mcp.json`:
```json
{
  "mcpServers": {
    "whatsapp": {
      "command": "uv",
      "args": [
        "run",
        "{{FULL_PATH_TO}}/whatsapp-mcp-server/main.py"
      ]
    }
  }
}
```

## Important Notes
- Replace `{{FULL_PATH_TO}}` with the actual full path to the whatsapp-mcp directory
- Restart Claude Desktop or Cursor after configuration
- Re-authentication required approximately every 20 days
- Messages stored locally in SQLite database

## Troubleshooting
- If messages out of sync, delete database files:
  - `whatsapp-bridge/store/messages.db`
  - `whatsapp-bridge/store/whatsapp.db`

## Available Tools
- Search contacts
- List messages
- Send messages
- Get chat history
