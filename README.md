# Claude Code Devcontainer for VPS

A secure, production-ready development container for Claude Code with network isolation and firewall protection.

## Features

- 🔒 **Secure by default** - Firewall blocks all outbound traffic except whitelisted domains
- 🐳 **Docker-based** - Runs in an isolated container
- 💻 **VS Code integration** - Works with Remote - Containers extension
- 🔧 **Developer tools included** - git, zsh, fzf, vim, nano, and more
- 📦 **Node.js 20** - Latest LTS version with Claude Code CLI pre-installed

## Quick Start

### Option 1: VS Code Remote Containers (Recommended)

1. Install [VS Code](https://code.visualstudio.com/) and the [Remote - Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
2. Clone this repository to your VPS
3. Open VS Code and connect to your VPS via Remote-SSH
4. Open this folder and click "Reopen in Container" when prompted

### Option 2: Docker CLI

```bash
# Build the devcontainer image
cd .devcontainer
docker build -t claude-code-sandbox .

# Run the container
docker run -it \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  -v $(pwd):/workspace \
  claude-code-sandbox \
  /bin/zsh
```

## VPS Setup

If your VPS doesn't have Docker installed, run:

```bash
sudo bash scripts/setup-docker.sh
```

## Security

The container implements a **default-deny firewall** that only allows connections to:

| Domain | Purpose |
|--------|---------|
| `registry.npmjs.org` | npm packages |
| `api.github.com` + GitHub IPs | Git operations |
| `api.anthropic.com` | Claude API |
| `statsig.anthropic.com` | Analytics |
| `marketplace.visualstudio.com` | VS Code extensions |

All other outbound connections are **blocked**.

## Running with Skip Permissions

For unattended operation, you can use:

```bash
claude --dangerously-skip-permissions
```

> ⚠️ **Warning**: Only use this mode when developing with trusted repositories. The devcontainer provides isolation but is not immune to all attacks.

## Customization

- Modify `devcontainer.json` to add/remove VS Code extensions
- Edit `Dockerfile` to install additional tools
- Update `init-firewall.sh` to whitelist additional domains

## License

[MIT](LICENSE)
