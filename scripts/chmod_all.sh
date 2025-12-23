#!/bin/bash

set -e

echo "🔐 Granting execute permission to all project scripts"

chmod +x \
  build_headers.sh \
  consolidate_summary.sh \
  convert_bandit_to_md.sh \
  convert_gitleaks_json_to_md.sh \
  display_elapsed.sh \
  elapsed.sh \
  run_bandit.sh \
  run_coverage.sh \
  run_gitleaks.sh \
  stop.sh \
  trivy-to-md.sh \
  trivy-to-md-full.sh \
  whoami_summary.sh \
  display_message.sh \
  install_security_tools.sh \
  run_mypy.sh \
  docker_ls.sh

echo "✅ All scripts are now executable"