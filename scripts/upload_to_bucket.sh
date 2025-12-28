#!/bin/bash

set -e

echo "### ☁️ Saving all data and uploading into S3 bucket" >> $GITHUB_STEP_SUMMARY

TIMESTAMP=$(date -u +"%Y%m%d-%H%M%S")
DATE_ONLY=$(date -u +"%Y%m%d")

ARTIFACT_NAME="security-artifacts-${GITHUB_REPOSITORY##*/}-${TIMESTAMP}-${GITHUB_RUN_ID}-${GITHUB_SHA::7}.zip"

REPO=${1}
STAGE=${2}
BUCKET=${3}

if [[ -z "$REPO" || -z "$STAGE" || -z "$BUCKET" ]]; then
    echo "❌ Error: Missing required parameters."
    echo "Usage: $0 <repo> <stage> <bucket>"
    exit 1
fi



# -------------------------------
# Artifact manifest (evidence)
# -------------------------------
cat <<EOF > artifact-manifest.txt
Repository: $GITHUB_REPOSITORY
Commit SHA: $GITHUB_SHA
Short SHA: ${GITHUB_SHA::7}
Run ID: $GITHUB_RUN_ID
Workflow: $GITHUB_WORKFLOW
Job: $GITHUB_JOB
Actor: $GITHUB_ACTOR
Generated at (UTC): $TIMESTAMP
Policy: High / Critical vulnerabilities block production
EOF
zip -r "$ARTIFACT_NAME"  *.json  *.html *.sarif  *.md artifact-manifest.txt
ARTIFACT_SIZE=$(stat -c%s "$ARTIFACT_NAME")
ARTIFACT_SIZE_HUMAN=$(du -h "$ARTIFACT_NAME" | cut -f1)
ls -la "$ARTIFACT_NAME"
S3_PATH="/$REPO/$STAGE/${DATE_ONLY}/${ARTIFACT_NAME}"

echo " " >> "$GITHUB_STEP_SUMMARY"
echo "| Field | Value |" >> "$GITHUB_STEP_SUMMARY"
echo "|------|-------|" >> "$GITHUB_STEP_SUMMARY"
echo "| 📦 Artifact name | actions-generarated-files-zip |" >> "$GITHUB_STEP_SUMMARY"
echo "| 📁 Artifact AWS path | \`$S3_PATH\` |" >> "$GITHUB_STEP_SUMMARY"
echo "| 📏 Artifact size | **$ARTIFACT_SIZE_HUMAN** |" >> "$GITHUB_STEP_SUMMARY"
echo "| 🕒 Generated at | UTC $TIMESTAMP |" >> "$GITHUB_STEP_SUMMARY"
echo "| 🚨 Policy | High / Critical block production |" >> "$GITHUB_STEP_SUMMARY"
echo "| 🪣  Bucket | \`$BUCKET\` |" >> "$GITHUB_STEP_SUMMARY"
echo "" >> "$GITHUB_STEP_SUMMARY"

echo "ARTIFACT_NAME=$ARTIFACT_NAME" >> "$GITHUB_ENV"

./display_elapsed.sh