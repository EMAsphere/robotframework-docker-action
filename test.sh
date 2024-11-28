# Authenticate with ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 719882381898.dkr.ecr.eu-central-1.amazonaws.com

# Create reports folder
REPORTS_DIR=$(pwd)/$ROBOT_REPORTS_DIR
TESTS_DIR=$(pwd)/$ROBOT_TESTS_DIR
sudo mkdir $REPORTS_DIR && sudo chmod 777 $REPORTS_DIR

pwd
ls

docker run --shm-size=$ALLOWED_SHARED_MEMORY \
  -e BROWSER=$BROWSER \
  -e ROBOT_THREADS=$ROBOT_THREADS \
  -e PABOT_OPTIONS="$PABOT_OPTIONS" \
  -e ROBOT_OPTIONS="$ROBOT_OPTIONS" \
  -v $REPORTS_DIR:/opt/robotframework/reports:Z \
  -v $TESTS_DIR:/opt/robotframework/tests:Z \
  -v $(pwd)/requirements-linux.txt:/opt/robotframework/pip-requirements.txt:Z \
  --user $(id -u):$(id -g) \
  $ROBOT_RUNNER_IMAGE
