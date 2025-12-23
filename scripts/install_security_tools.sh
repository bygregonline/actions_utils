#!/usr/bin/env bash
set -euo pipefail
echo "🔧 Installing security tools..."

# ---------------------------
# Install Syft (official Anchore installer)
# ---------------------------


echo "📦 Installing Syft  "
curl -sSfL https://get.anchore.io/syft | sudo sh -s -- -b /usr/local/bin
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

docker pull anchore/grype:latest
docker pull ghcr.io/gitleaks/gitleaks:latest
docker pull sonarqube:community

echo "✅ Security tools installed successfully"