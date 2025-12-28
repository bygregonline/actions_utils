#!/bin/bash

docker run --rm anchore/grype version


docker run --rm -v ./sbom-amazon-linux-report.json:/mnt/sbom.json -v .:/mnt/output   anchore/grype sbom:/mnt/sbom.json -o sarif --file /mnt/output/sbom-amazon-linux-report.sarif
echo "docker ubuntu v3"
docker run --rm -v ./sbom-python-src-report.json:/mnt/sbom.json -v .:/mnt/output   anchore/grype sbom:/mnt/sbom.json -o sarif --file /mnt/output/sbom-src-report.sarif

./trivy-to-md.sh sbom-amazon-linux-report.sarif sbom-amazon-linux-report.md "$AMAZON_LINUX_CONTAINER"
./trivy-to-md-full.sh sbom-amazon-linux-report.sarif sbom-amazon-linux-full-report.md "$AMAZON_LINUX_CONTAINER"
./trivy-to-md.sh sbom-src-report.sarif sbom-src-report.md "python_src"
./trivy-to-md-full.sh sbom-src-report.sarif  sbom-src-full-report.md "python_src"


echo "### ⚠️ Syft / Grype SBOM vulnerabilities report " >> $GITHUB_STEP_SUMMARY
echo "- 🧾 **SBOM format**: SPDX" >> $GITHUB_STEP_SUMMARY
echo "- 🔍 **Scanner**: Grype" >> $GITHUB_STEP_SUMMARY
echo "- 📐 **Security policy**: High / Critical severity" >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY

echo "<img alt='Syft badge' src='https://img.shields.io/badge/syft%20grype-SBOM%20vulnerabilities-blue'> " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY

echo "##### artifacts " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY


echo " " >> $GITHUB_STEP_SUMMARY
echo "| icon | Artifacts | format | " >> "$GITHUB_STEP_SUMMARY"
echo "|------|----------|------------------|" >> "$GITHUB_STEP_SUMMARY"

echo "|📄| **sbom-amazon-linux-full-report-md**| **md** |" >> "$GITHUB_STEP_SUMMARY"
echo "|📄| **sbom-src-full-report-md**| **md** |" >> "$GITHUB_STEP_SUMMARY"

echo "|📄| **sbom-amazon-linux-simplified-report-md**| **md** |" >> "$GITHUB_STEP_SUMMARY"
echo "|📄| **sbom-src-simplified-report-md**| **md** |" >> "$GITHUB_STEP_SUMMARY"
echo "|🛠️| **sbom-amazon-linux-report-json**| **json** |" >> "$GITHUB_STEP_SUMMARY"
echo "|🛠️| **sbom-src-report-json**| **json** |" >> "$GITHUB_STEP_SUMMARY"
echo "|🔬| **sbom-amazon-linux-report-sarif**| **sarif** |" >> "$GITHUB_STEP_SUMMARY"
echo "|🔬| **sbom-src-report-sarif**| **sarif** |" >> "$GITHUB_STEP_SUMMARY"


echo " " >> $GITHUB_STEP_SUMMARY


echo "### ☣️ Showing vulnerabilities in SBOM for Amazon Linux base image" >> $GITHUB_STEP_SUMMARY


VULNERABILITIES_COUNT=$(jq '[.runs[]?.results[]? | select(.message.text | test("^A (high|critical)"))] | length' sbom-amazon-linux-report.sarif)
if [[ "$VULNERABILITIES_COUNT" -eq 0 ]]; then
echo " " >> $GITHUB_STEP_SUMMARY
echo "| Msg | Value |" >> $GITHUB_STEP_SUMMARY
echo "|--------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| 📊 Vulnerabilities found | 0 |" >> $GITHUB_STEP_SUMMARY
echo "| ✅ Status | **OK** |" >> $GITHUB_STEP_SUMMARY


else
cat sbom-amazon-linux-report.md >> $GITHUB_STEP_SUMMARY
fi

echo " " >> $GITHUB_STEP_SUMMARY

./display_message.sh "$VULNERABILITIES_COUNT"


echo "### ☣️ Showing vulnerabilities in python src SBOM" >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY




VULNERABILITIES_COUNT=$(jq '[.runs[]?.results[]? | select(.message.text | test("^A (high|critical)"))] | length' sbom-src-report.sarif)

echo "$VULNERABILITIES_COUNT vulnerabilities found" >> $GITHUB_STEP_SUMMARY
echo $VULNERABILITIES_COUNT

if [[ "$VULNERABILITIES_COUNT" -eq 0 ]]; then

echo " " >> $GITHUB_STEP_SUMMARY
echo "| Msg | Value |" >> $GITHUB_STEP_SUMMARY
echo "|--------|--------|" >> $GITHUB_STEP_SUMMARY
echo "| 📊 Vulnerabilities found | 0 |" >> $GITHUB_STEP_SUMMARY
echo "| ✅ Status | **OK** |" >> $GITHUB_STEP_SUMMARY


else
cat sbom-src-report.md >> $GITHUB_STEP_SUMMARY
fi

echo " " >> $GITHUB_STEP_SUMMARY
./display_message.sh "$VULNERABILITIES_COUNT"


./display_elapsed.sh
echo "--- " >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY