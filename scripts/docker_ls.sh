#!/bin/bash

echo "| ICON | REPOSITORY | TAG | IMAGE ID | CREATED | SIZE |"
echo "|------|------------|-----|----------|---------|------|"

docker image ls --format "{{.Repository}}|{{.Tag}}|{{.ID}}|{{.CreatedAt}}|{{.Size}}" | while IFS='|' read -r repository tag id created size; do
    echo "| 🐳 | $repository | $tag | $id | $created | $size |"
done