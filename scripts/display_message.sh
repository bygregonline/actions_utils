#!/bin/bash
  _INPUT=${1}
  if [ "$_INPUT" == "0" ]; then
    echo "#### ✅ At this point the pipeline its ok " >> $GITHUB_STEP_SUMMARY
  else
    echo "#### ⛔ It must stop the pipeline at production " >> $GITHUB_STEP_SUMMARY
  fi