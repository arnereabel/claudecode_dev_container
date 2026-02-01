#!/bin/bash
# Docker Installation Script for Ubuntu VPS
# Run as root or with sudo

set -euo pipefail

echo "=== Docker Installation Script for Claude Code Devcontainer ==="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo"
    exit 1
fi

# Remove old Docker installations
echo "Removing old Docker installations..."
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Update package index
echo "Updating package index..."
apt-get update

# Install prerequisites
echo "Installing prerequisites..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
echo "Adding Docker GPG key..."
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
echo "Installing Docker Engine..."
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker daemon for logging limits
echo "Configuring Docker daemon..."
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF

# Restart Docker to apply configuration
systemctl restart docker

# Add current user to docker group (if not root)
SUDO_USER=${SUDO_USER:-}
if [ -n "$SUDO_USER" ]; then
    echo "Adding $SUDO_USER to docker group..."
    usermod -aG docker "$SUDO_USER"
    echo "NOTE: Log out and back in for group changes to take effect"
fi

# Verify installation
echo ""
echo "=== Verifying Docker Installation ==="
docker --version
docker compose version

echo ""
echo "=== Docker Installation Complete ==="
echo "You can now use Docker to run the Claude Code devcontainer"
