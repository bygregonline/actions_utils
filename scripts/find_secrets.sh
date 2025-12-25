#!/bin/bash

echo "### 🛡️ Gitleaks Report" >> $GITHUB_STEP_SUMMARY
echo "<img alt='gitleaks badge' src='https://img.shields.io/badge/protected%20by-gitleaks-blue'> " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY
if [[ -z "$MAX_GITHUB_LEVELS" ]]; then
echo "##### MAX_GITHUB_LEVELS is not defined. Using -100 as default value" >> $GITHUB_STEP_SUMMARY
MAX_GITHUB_LEVELS=-100
else

echo "##### MAX_GITHUB_LEVELS has been defined as ${MAX_GITHUB_LEVELS}" >> $GITHUB_STEP_SUMMARY
fi

docker run -v "$(pwd):/path" ghcr.io/gitleaks/gitleaks:latest detect --source=/path --report-path=/path/gitleaks-report.json --verbose --log-opts="${MAX_GITHUB_LEVELS}" --exit-code=0
ls -la
echo " " >> $GITHUB_STEP_SUMMARY
./convert_gitleaks_json_to_md.sh gitleaks-report.json gitleaks-report.md

FINDINGS_COUNT=$(jq '. | length' gitleaks-report.json)

# If no vulnerabilities found
if [[ "$FINDINGS_COUNT" -eq 0 ]]; then
  echo "### ✅ No Secrets Detected" >> "$GITHUB_STEP_SUMMARY"
  echo "🟢 **Everything looks good!**" >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
  echo "Gitleaks did not detect any secrets or sensitive information in this repository." >> "$GITHUB_STEP_SUMMARY"
  echo "" >> "$GITHUB_STEP_SUMMARY"
  echo "| Status | Result |" >> "$GITHUB_STEP_SUMMARY"
  echo "|--------|--------|" >> "$GITHUB_STEP_SUMMARY"
  echo "| 🔐 Security Scan | ✅ Clean |" >> "$GITHUB_STEP_SUMMARY"

else
    cat gitleaks-report.md >> $GITHUB_STEP_SUMMARY
    echo " " >> "$GITHUB_STEP_SUMMARY"
fi


echo " " >> $GITHUB_STEP_SUMMARY
echo "| icon | Artifacts | format | " >> $GITHUB_STEP_SUMMARY
echo "|------|----------|------------------|" >> $GITHUB_STEP_SUMMARY
echo "|📄| **gitleaks-report-md**| **md** |" >> $GITHUB_STEP_SUMMARY
echo "|🛠️ |**gitleaks-report-json**| **json** |" >> $GITHUB_STEP_SUMMARY
./display_message.sh "$(jq '. | length' gitleaks-report.json)"
./display_elapsed.sh
echo "---" >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY