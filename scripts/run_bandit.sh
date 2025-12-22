#!/bin/bash

set -e

TARGET_PATH=${1:-python/fastapi}

bandit -lll -ii -r "$TARGET_PATH" -f html -o bandit.html --exit-zero
bandit -ll  -i  -r "$TARGET_PATH" -f json -o bandit.json --exit-zero

./convert_bandit_to_md.sh bandit.json bandit_summary.md

{
  echo "### 📄 Bandit SAST Report"
  echo "<img alt='Bandit badge' src='https://img.shields.io/badge/Bandit-SAST%20Report-blue'>"
  echo ""
  cat bandit_summary.md
  echo ""
  echo "| icon | Artifacts | format |"
  echo "|------|----------|--------|"
  echo "|📄| **bandit-md-report** | **md** |"
  echo "|🛠️| **bandit-json-report** | **json** |"
  echo "|🌐| **bandit-html-report** | **html** |"
} >> "$GITHUB_STEP_SUMMARY"

./display_message.sh "$(jq '.results | length' bandit.json)"
./display_elapsed.sh

{
  echo "---"
  echo "##### NEXT ➡️"
} >> "$GITHUB_STEP_SUMMARY"