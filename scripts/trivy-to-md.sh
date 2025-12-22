#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: $0 <input-json> <output-md> <image-name>"
  exit 1
fi

INPUT_JSON=$1
OUTPUT_MD=$2
TITLE=$3

if [ ! -f "$INPUT_JSON" ]; then
  echo "Error: Input JSON file '$INPUT_JSON' does not exist."
  exit 1
fi

VULNERABILITIES_COUNT=$(jq '[.runs[]?.results[]? | select(.message.text | test("^A (high|critical)"))] | length' "$INPUT_JSON")
VULNERABILITIES_TOTAL=$(jq '[.runs[]?.results[]?] | length' "$INPUT_JSON")

if [[ "$VULNERABILITIES_COUNT" -eq 0 ]]; then
  echo "Trivy is empty" >> "$OUTPUT_MD"
  exit 0
fi

BADGE_URL_TOTAL="https://img.shields.io/badge/$TITLE-vulnerabilities:total:$VULNERABILITIES_TOTAL-blue"
BADGE_URL="https://img.shields.io/badge/$TITLE-vulnerabilities:risk:$VULNERABILITIES_COUNT-red"

{
  echo "<img src=\"$BADGE_URL_TOTAL\" height=\"20\">"
  echo "<img src=\"$BADGE_URL\" height=\"20\">"
  echo ""
  echo "##### Total Vulnerabilities $VULNERABILITIES_TOTAL @ $TITLE"
  echo "##### Vulnerabilities $VULNERABILITIES_COUNT found (HIGH and CRITICAL only)"
  echo ""
  echo "| |Vulnerability ID | Description | Severity | Path |"
  echo "|----|------------------|-------------|----------|------|"
} >> "$OUTPUT_MD"

jq -r '
.runs[]?.results[]? |
(if .message.text | test("^A (high|critical)") then
  if .message.text | startswith("A high") then "**HIGH**"
  elif .message.text | startswith("A critical") then "**CRITICAL**"
  else empty end
else empty end) as $severity |
"| ☣️ | \(.ruleId // "N/A") | \(.message.text // "N/A") | \($severity) | \(.locations[0].physicalLocation.artifactLocation.uri // "N/A") |"
' "$INPUT_JSON" >> "$OUTPUT_MD"