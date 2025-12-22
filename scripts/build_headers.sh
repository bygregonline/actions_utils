#!/bin/bash

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
TRIGGER_USER=${GITHUB_TRIGGERING_ACTOR:-${GITHUB_ACTOR:-unknown}}

{
  echo "```"
  echo "⏰ Starting at: $START_TIME"
  echo "🏎️💨 Triggered by: $TRIGGER_USER"
  echo "```"
} >> "$GITHUB_STEP_SUMMARY"