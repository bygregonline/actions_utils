#!/usr/bin/env bash
set +e

TARGET=${1:-python}
RAW_REPORT=mypy-raw.txt
TABLE_REPORT=mypy-table.md

echo "🔍 Running mypy on: $TARGET"

mypy "$TARGET" \
  --ignore-missing-imports \
  --pretty \
  --show-error-codes \
  > "$RAW_REPORT" 2>&1

EXIT_CODE=$?

echo "### 🧠 MyPy Type Checking Report" >> "$GITHUB_STEP_SUMMARY"
echo "<img alt='mypy badge' src='https://img.shields.io/badge/mypy-type%20check-blue'>" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

# Si no hay errores
if [[ "$EXIT_CODE" -eq 0 ]]; then
  echo "#### ✅ No type errors found by mypy." >> "$GITHUB_STEP_SUMMARY"
  exit 0
fi

# Header de tabla
echo "| File | Line | Message | Code |" > "$TABLE_REPORT"
echo "|------|------|---------|------|" >> "$TABLE_REPORT"

# Parsear salida de mypy
grep -E "^[^:]+:[0-9]+:" "$RAW_REPORT" | while IFS= read -r line; do
  FILE=$(echo "$line" | cut -d: -f1)
  LINE_NO=$(echo "$line" | cut -d: -f2)
  MESSAGE=$(echo "$line" | sed -E 's/^[^:]+:[0-9]+: (error|note): //')
  CODE=$(echo "$line" | grep -oE '\[[a-zA-Z0-9\-]+\]' | tr -d '[]')

  echo "| \`$FILE\` | $LINE_NO | $MESSAGE | $CODE |" >> "$TABLE_REPORT"
done

echo "⚠️ **Type errors detected by mypy**" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

cat "$TABLE_REPORT" >> "$GITHUB_STEP_SUMMARY"

exit 0