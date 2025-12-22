#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Uso: $0 <ruta_del_archivo> [GET_TIME]"
    exit 1
fi

file_path=$1
get_time=${2:-DEFAULT}

if [ ! -e "$file_path" ]; then
    echo "El archivo '$file_path' no existe."
    exit 1
fi

file_creation_time=$(stat -c %Y "$file_path")
current_time=$(date +%s)
time_diff=$((current_time - file_creation_time))

days=$((time_diff / 86400))
hours=$(( (time_diff % 86400) / 3600 ))
minutes=$(( (time_diff % 3600) / 60 ))
seconds=$((time_diff % 60))

elapsed_time="$minutes:$seconds"

if [ "$get_time" == "GET_TIME" ]; then
    echo "$elapsed_time"
else
    {
      echo "<br/><br/><br/><br/><br/><br/>"
      echo "---"
      echo "🏁 GitHub Actions took $minutes:$seconds minutes:seconds to complete."
    } >> "$GITHUB_STEP_SUMMARY"

    echo "$elapsed_time"
fi