#!/bin/bash

set -e


{
echo "### 🧭 Security Scanning Strategy"
echo " "
echo "The following table explains the **role and scope** of each security scanning stage"
echo "implemented in this CI/CD pipeline:"
echo " "
echo "| Dimension | Trivy Scan | SBOM Scan (Syft + Grype) |"
echo "|----------|------------|--------------------------|"
echo "| **Type** | Direct vulnerability scanner | Scanner with policy enforcement |"
echo "| **Input** | Docker image (runtime) | SBOM (build-time) |"
echo "| **Tooling** | Trivy | Syft + Grype |"
echo "| **Focus** | Container & OS packages | Supply chain & dependencies |"
echo "| **Pipeline role** | Evidence generation | Security gate / decision point |"
echo " "
echo "> **Note:** These scans are **complementary**, not redundant."
echo "> Together they provide defense-in-depth and supply-chain security coverage."
echo " "
} >> "$GITHUB_STEP_SUMMARY"
./display_elapsed.sh
echo "--- " >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY