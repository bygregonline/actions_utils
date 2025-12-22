#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <output-md>"
  exit 1
fi

OUTPUT_FILE=$1

echo "# Consolidated Step Summaries" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

for summary_file in $(ls /home/runner/work/_temp/_runner_file_commands/step_summary_* \
  | grep -v '\-scrubbed$' \
  | xargs -I {} stat --format '%W %n' {} \
  | sort -n \
  | cut -d' ' -f2); do

  cat "$summary_file" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
done