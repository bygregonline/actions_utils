#!/bin/bash

INPUT_FILE=$1
OUTPUT_FILE=$2

if [[ -z "$INPUT_FILE" || -z "$OUTPUT_FILE" ]]; then
  echo "Usage: $0 <input-json> <output-md>"
  exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "❌ File does not exist: $INPUT_FILE" >> "$GITHUB_STEP_SUMMARY"
  exit 1
fi

echo "" >> "$OUTPUT_FILE"
echo "| File | Line | Secret Found | Commit |" >> "$OUTPUT_FILE"
echo "|------|------|--------------|--------|" >> "$OUTPUT_FILE"

jq -r '
.[] |
"| `" + .File + "` | `" + (.StartLine | tostring) + "` | `" + .Description + "` | `" + .Commit + "` |"
' "$INPUT_FILE" >> "$OUTPUT_FILE"

echo "✅ Markdown report generated at '$OUTPUT_FILE'"