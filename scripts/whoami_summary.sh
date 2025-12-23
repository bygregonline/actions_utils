#!/bin/bash

{
  echo '```'
  echo "👤 User:"
  whoami
  echo ""
  echo "📁 Working directory:"
  pwd
  echo ""
  echo "📦 Directory listing:"
  ls -la
  echo '```'
} >> "$GITHUB_STEP_SUMMARY"