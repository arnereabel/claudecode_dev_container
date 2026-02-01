# Claude Code Devcontainer for VPS

A secure, production-ready development container for Claude Code with network isolation and firewall protection.

## 🚀 Quick Start (VPS Deployed)

This devcontainer is running on a Hetzner VPS with:
- **OS**: Ubuntu 24.04
- **Docker**: v28.2.2  
- **Claude Code**: v2.1.29 (Opus 4.5)
- **Container**: `claude-sandbox`

### Connect via VS Code

1. Install [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension
2. SSH to VPS: `ssh root@89.167.13.134`
3. Open folder: `/root/claudecode_dev_container`
4. Use "Attach to Running Container" → `claude-sandbox`

### Run with Skip Permissions (Unattended Mode)

```bash
# Inside the container
claude --dangerously-skip-permissions
```

> ⚠️ The firewall blocks all outbound traffic except npm, GitHub, and Claude API. Safe for unattended operation.

---

## Features

- 🔒 **Secure by default** - Firewall blocks all outbound traffic except whitelisted domains
- 🐳 **Docker-based** - Runs in an isolated container
- 💻 **VS Code integration** - Works with Remote - Containers extension  
- 🔧 **Developer tools** - git, zsh, fzf, vim, nano, and more
- 📦 **Node.js 20** - Latest LTS with Claude Code CLI

## Security

The container implements a **default-deny firewall**:

| Allowed | Purpose |
|---------|---------|
| `registry.npmjs.org` | npm packages |
| GitHub IPs | Git operations |
| `api.anthropic.com` | Claude API |
| VS Code domains | Extensions |

All other outbound connections are **blocked**.

## Project Structure

```
claudecode_dev_container/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── Dockerfile
│   └── init-firewall.sh
├── fpx/              ← Project workspace
├── scripts/
│   └── setup-docker.sh
├── CLAUDE.md         ← Instructions for Claude
└── README.md
```

## Container Commands

```bash
# Start container (if stopped)
docker start claude-sandbox

# Attach to container
docker exec -it claude-sandbox zsh

# View logs
docker logs claude-sandbox

# Restart with fresh firewall
docker restart claude-sandbox
```

## License

MIT
