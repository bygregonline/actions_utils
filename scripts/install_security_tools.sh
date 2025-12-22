#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Installing security tools..."

# ---------------------------
# Install Syft (official Anchore installer)
# ---------------------------
SYFT_VERSION="0.94.0"

echo "📦 Installing Syft v${SYFT_VERSION}"
curl -sSfL https://get.anchore.io/syft | sudo sh -s -- -b /usr/local/bin "v${SYFT_VERSION}"
syft --version

# ---------------------------
# Install Tryvy (official Aqua Security installer) and HTML template
# ---------------------------

curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
curl -sSfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/html.tpl -o trivy-html.tpl

# ---------------------------
# Pull Docker images
# ---------------------------
echo "🐳 Pulling Docker images"

docker pull anchore/grype:0.80.0
docker pull ghcr.io/gitleaks/gitleaks:v8.18.2
docker pull sonarqube:latest

echo "✅ Security tools installed successfully"