#!/bin/bash

START_TIME=$(date +"%Y-%m-%d %H:%M:%S")
TRIGGER_USER=${GITHUB_TRIGGERING_ACTOR:-${GITHUB_ACTOR:-unknown}}
OS_USER=$(whoami)
{
  echo "### 🧾  Consolidated steps report. " >> "$GITHUB_STEP_SUMMARY"
  echo "##### 🔍  Results. " >> "$GITHUB_STEP_SUMMARY"
  echo " " >> "$GITHUB_STEP_SUMMARY"
  echo " " >> "$GITHUB_STEP_SUMMARY"
  echo "---" >> "$GITHUB_STEP_SUMMARY"
  echo " " >> "$GITHUB_STEP_SUMMARY"

  echo '```'

  echo "⏰ Starting at: $START_TIME"
  echo "🏎️💨 Triggered by: $TRIGGER_USER"
  echo "👤 User: $OS_USER"
  echo "📁 Working directory: $(pwd)"


  echo '```'
} >> "$GITHUB_STEP_SUMMARY"