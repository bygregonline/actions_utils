#!/bin/bash

{
  echo "<br/><br/>"
  echo "---"
  echo "## 🛑 The Process has been stopped by user at some point"
  echo "<br/><br/>"
} >> "$GITHUB_STEP_SUMMARY"

exit 1