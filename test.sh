# Authenticate with ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 719882381898.dkr.ecr.eu-central-1.amazonaws.com

# Debug AWS identity and S3 access
echo "Current AWS identity:"
aws sts get-caller-identity

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
  -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  -e AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
  -e AWS_BUCKET_NAME=$AWS_BUCKET_NAME \
  -e AWS_RUN_DIR=$AWS_RUN_DIR \
  ${AWS_BUCKET_NAME:+-e AWS_UPLOAD_TO_S3="true"} \
  -v $REPORTS_DIR:/opt/robotframework/reports:Z \
  -v $TESTS_DIR:/opt/robotframework/tests/test:Z \
  -v $(pwd)/$ROBOT_RESOURCES_DIR:/opt/robotframework/$ROBOT_RESOURCES_DIR:Z \
  -v $(pwd)/requirements-linux.txt:/opt/robotframework/pip-requirements.txt:Z \
  --user $(id -u):$(id -g) \
  $ROBOT_RUNNER_IMAGE

ROBOT_EXIT_CODE=$?

if [ $ROBOT_EXIT_CODE -eq 252 ]; then
    echo "::warning::No tests were found matching the specified criteria. This is not considered a failure."
    exit 0
elif [ $ROBOT_EXIT_CODE -ne 0 ]; then
    echo "::error::Robot Framework tests failed with exit code $ROBOT_EXIT_CODE"
    exit $ROBOT_EXIT_CODE
fi
