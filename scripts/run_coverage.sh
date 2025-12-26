#!/bin/bash

set -e

# Validate first parameter
if [ -z "$1" ]; then
  echo "❌ Must provide the target test directory as the first argument."
  echo "👉 Uso: $0 tests/unit/core/"
  exit 255
fi
pytest "$1"

echo "### 📊 Coverage report " >> $GITHUB_STEP_SUMMARY
echo "<img alt='Coverage badge' src='https://img.shields.io/badge/python-coverage-blue'> " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY
coverage report --format markdown >> $GITHUB_STEP_SUMMARY
coverage report --format markdown > coverage-report-md.md
echo " " >> $GITHUB_STEP_SUMMARY

echo "| icon | Artifacts | format | " >> $GITHUB_STEP_SUMMARY
echo "|------|----------|------------------|" >> $GITHUB_STEP_SUMMARY
echo "|🌐 | **coverage-report-html**| **md** |" >> $GITHUB_STEP_SUMMARY
echo "|🛠️ | **coverage-report-md**| **md** |" >> $GITHUB_STEP_SUMMARY

coverage html
zip -r htmlcoverage.zip  htmlcov
coverage_output=$(coverage report --format text)
total_line=$(echo "$coverage_output" | grep "TOTAL")
covered=$(echo "$total_line" | awk '{print $NF}' | tr -d '%')
uncovered=$((100 - covered))
echo "##### Coverage:  🟩 ${covered}% covered, 🟥    ${uncovered}% uncovered " >> $GITHUB_STEP_SUMMARY
if [[ -z "$MIN_COVERAGE" ]]; then
echo "##### MIN_COVERAGE is not defined. Using 80% as default value" >> $GITHUB_STEP_SUMMARY
MIN_COVERAGE=80
else

echo "##### MIN_COVERAGE has been defined as ${MIN_COVERAGE}%" >> $GITHUB_STEP_SUMMARY
fi

if (( covered >= MIN_COVERAGE )); then
  ./display_message.sh 0
else
  ./display_message.sh 1
fi

./display_elapsed.sh
echo "--- " >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY