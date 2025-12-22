#!/bin/bash
set -e

MIN_COVERAGE_DEFAULT=80

uv venv .ubuntu-venv
source .ubuntu-venv/bin/activate
source ./python/fastapi/setenv-ubuntu-cd-ci-github.sh

uv pip install -r requirements_dev.txt
coverage run -m pytest

{
  echo "### 📊 Coverage report"
  echo "<img alt='Coverage badge' src='https://img.shields.io/badge/Python-Coverage-blue'>"
  echo ""
} >> "$GITHUB_STEP_SUMMARY"

coverage report --format markdown >> "$GITHUB_STEP_SUMMARY"
coverage report --format markdown > coverage-report-md.md

{
  echo ""
  echo "| icon | Artifacts | format |"
  echo "|------|----------|--------|"
  echo "|🌐| **coverage-report-html** | **html** |"
  echo "|🛠️| **coverage-report-md** | **md** |"
} >> "$GITHUB_STEP_SUMMARY"

coverage html
zip -r htmlcoverage.zip htmlcov

coverage_output=$(coverage report --format text)
total_line=$(echo "$coverage_output" | grep "TOTAL")
covered=$(echo "$total_line" | awk '{print $NF}' | tr -d '%')
uncovered=$((100 - covered))

{
  echo "##### Coverage: 🟩 ${covered}% covered, 🟥 ${uncovered}% uncovered"
} >> "$GITHUB_STEP_SUMMARY"

if [[ -z "$MIN_COVERAGE" ]]; then
  {
    echo "##### MIN_COVERAGE is not defined. Using ${MIN_COVERAGE_DEFAULT}% as default value"
  } >> "$GITHUB_STEP_SUMMARY"
  MIN_COVERAGE=$MIN_COVERAGE_DEFAULT
else
  {
    echo "##### MIN_COVERAGE has been defined as ${MIN_COVERAGE}%"
  } >> "$GITHUB_STEP_SUMMARY"
fi

if (( covered >= MIN_COVERAGE )); then
  ./display_message.sh 0
else
  ./display_message.sh 1
fi

./display_elapsed.sh

{
  echo "---"
  echo "##### NEXT ➡️"
} >> "$GITHUB_STEP_SUMMARY"