#!/bin/bash

INPUT=${1:-bandit_output.json}
OUTPUT=${2:-$GITHUB_STEP_SUMMARY}

if [[ ! -f "$INPUT" ]]; then
  echo "❌ Bandit input not found" >> "$OUTPUT"
  exit 1
fi

COUNT=$(jq '.results | length' "$INPUT")

if [[ "$COUNT" -eq 0 ]]; then
  echo "✅ No Bandit issues found." >> "$OUTPUT"
else
  {
    echo "| File | Line | Test ID | Severity | Issue |"
    echo "|------|------|---------|----------|-------|"
  } >> "$OUTPUT"

  jq -r '.results[] |
  "| `\(.filename)` | `\(.line_number)` | \(.test_id) | \(.issue_severity) | \(.issue_text) |"' "$INPUT" >> "$OUTPUT"
fi