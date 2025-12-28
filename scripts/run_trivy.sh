#!/bin/bash


set -e

TAR_FILE="$AMAZON_LINUX_TAR"
JSON_REPORT="trivy-image-amazonlinux-report.json"
HTML_REPORT="trivy-image-amazonlinux-report.html"
MD_REPORT="trivy-image-amazonlinux-report.md"

echo "📦 Saving image to tar"
docker save -o "$TAR_FILE" "$AMAZON_LINUX_CONTAINER"
ls -lh "$TAR_FILE"

echo "🔍 Trivy scan (JSON)"
trivy image \
--input "$TAR_FILE" \
--format json \
--severity CRITICAL,HIGH \
--exit-code 0 \
--timeout 6m \
--output "$JSON_REPORT"

echo "🌐 Trivy scan (HTML)"
trivy image \
--input "$TAR_FILE" \
--format template \
--template @trivy-html.tpl \
--timeout 6m \
--output "$HTML_REPORT"

echo "📝 Generating Markdown report"
{
echo "### 🐳 Trivy Image Scan (Amazon Linux)"
echo ""
echo "| Package | Vulnerability | Severity | Installed | Fixed |"
echo "|--------|---------------|----------|-----------|-------|"
jq -r '
    .Results[]?.Vulnerabilities[]? |
    "| `" + .PkgName + "` | `" + .VulnerabilityID + "` | **" + .Severity + "** | `" + .InstalledVersion + "` | `" + (.FixedVersion // "-") + "` |"
' "$JSON_REPORT"
} > "$MD_REPORT"

VULNERABILITIES_COUNT=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity=="CRITICAL" or .Severity=="HIGH")] | length' "$JSON_REPORT")

if [[ "$VULNERABILITIES_COUNT" -eq 0 ]]; then
    echo "#### ✅ No vulnerabilities found in Amazon Linux container image!" >> "$GITHUB_STEP_SUMMARY"
else
    echo "#### ⚠️ $VULNERABILITIES_COUNT vulnerabilities found in Amazon Linux container image" >> "$GITHUB_STEP_SUMMARY"
    cat "$MD_REPORT" >> "$GITHUB_STEP_SUMMARY"
fi



echo "📌 Publishing summary"
{

echo " "
echo "##### The following artifacts are generated as part of the **Trivy container image scan**"

echo " "
echo "Icon | Artifact | Format | Purpose |"
echo "|-|---------|--------|---------|"
echo "| 🛠️ | **trivy-image-report-amazonlinux-container-json** | JSON | Raw vulnerability data (automation & integrations) |"
echo "| 🌐 | **trivy-image-report-amazonlinux-container-html** | HTML | Human-readable security report |"
echo "| 📄 | **trivy-image-report-amazonlinux-container-md** | Markdown | CI/CD summary & audit-friendly report |"
echo " "

echo " "
} >> "$GITHUB_STEP_SUMMARY"

echo '```'  >> "$GITHUB_STEP_SUMMARY"
echo "🐳 **Scan scope**: Docker image (Amazon Linux base image)"  >> "$GITHUB_STEP_SUMMARY"
echo "🚨 **Severity policy**: High / Critical" >> "$GITHUB_STEP_SUMMARY"
echo "🔍 **Tool**: Trivy" >> "$GITHUB_STEP_SUMMARY"
echo '```'>> "$GITHUB_STEP_SUMMARY"




echo " done" >> $GITHUB_STEP_SUMMARY
./display_elapsed.sh
echo "--- " >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY