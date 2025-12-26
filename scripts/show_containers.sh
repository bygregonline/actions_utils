./dockers/build_docker.sh
echo "### 🐳 Building and showing docker containers " >> $GITHUB_STEP_SUMMARY
echo "<img alt='Coverage badge' src='https://img.shields.io/badge/containers%20engine-docker-blue'> " >> $GITHUB_STEP_SUMMARY


echo " " >> $GITHUB_STEP_SUMMARY
./docker_ls.sh  >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY
./display_elapsed.sh
echo "--- " >> $GITHUB_STEP_SUMMARY
echo "##### NEXT ➡️ " >> $GITHUB_STEP_SUMMARY
echo " " >> $GITHUB_STEP_SUMMARY