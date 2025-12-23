#!/bin/bash

START_TIME=$(./elapsed.sh elapsed.sh GET_TIME)
DISK=$(df -h | grep '/dev/root' | awk '{print $5 " of " $2}')
MEM=$(free -h | awk '/Mem:/ {print $3 " of " $2}')

{
  echo '```'
  echo "⏰ Elapsed time: $START_TIME"
  echo "💾 Disk: $DISK"
  echo "📦 Memory: $MEM"
  echo '```'
} >> "$GITHUB_STEP_SUMMARY"