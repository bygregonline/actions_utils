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
  ls -la src/
  echo '```'
} >> "$GITHUB_STEP_SUMMARY"