#!/bin/bash

{
  echo '```'

  ls -la
  ls -la src/
  echo '```'
} >> "$GITHUB_STEP_SUMMARY"