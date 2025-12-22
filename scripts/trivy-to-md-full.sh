#!/bin/bash

if [ $# -lt 3 ]; then
  echo "Usage: $0 <input-json> <output-md> <image-name>"
  exit 1
fi

INPUT_JSON=$1
OUTPUT_MD=$2
TITLE=$3

VULNERABILITIES_COUNT=$(jq '[.runs[]?.results[]?] | length' "$INPUT_JSON")

if [[ "$VULNERABILITIES_COUNT" -eq 0 ]]; then
  echo "No vulnerabilities found." >> "$OUTPUT_MD"
  exit 0
fi

{
  echo "#### Vulnerabilities $VULNERABILITIES_COUNT found @ $TITLE"
  echo "| Path | Severity | Vulnerability ID | Package |"
  echo "|------|----------|------------------|---------|"
} >> "$OUTPUT_MD"

jq -r '
.runs[]?.results[]? |
"| \(.ruleId) | \(.message.text) | \(.message.text | split(" ")[1] | ascii_upcase) | \(.locations[0].physicalLocation.artifactLocation.uri) |"
' "$INPUT_JSON" >> "$OUTPUT_MD"