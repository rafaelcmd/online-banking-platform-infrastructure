#!/bin/bash

set -e

# Paths to CloudFormation templates
ECS_TEMPLATE="../cloudformation/ecs/ecs-template.yaml"

# AWS CLI path
AWS_CLI="/usr/local/bin/aws"

# Create the ECS Fargate stack
echo "Creating or retrieving ECR repository and pushing Docker image..."

# Check if the ECR repository exists and get the URI
REPO_URI=$($AWS_CLI ecr describe-repositories --repository-names online-bank-auth-service --region us-east-2 --query 'repositories[0].repositoryUri' --output text 2>/dev/null || true)

if [ -z "$REPO_URI" ]; then
    echo "ECR repository does not exist. Creating repository..."
    REPO_URI=$($AWS_CLI ecr create-repository --repository-name online-bank-auth-service --region us-east-2 --query 'repository.repositoryUri' --output text)
else
    echo "ECR repository already exists. Using existing repository URI: $REPO_URI"
fi

# Tag the Docker image with the repository URI
docker tag my-online-bank-auth-service:latest $REPO_URI:latest

# Push the Docker image to ECR
$AWS_CLI ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $REPO_URI
docker push $REPO_URI:latest

# Full image name
FULL_IMAGE_NAME=$REPO_URI:latest

# Create CloudWatch log group
echo "Creating CloudWatch log group..."
$AWS_CLI logs create-log-group --log-group-name /ecs/online-bank-platform --region us-east-2 || true

# Deploy ECS Fargate stack with the full image name as a parameter
echo "Deploying ECS Fargate stack..."
$AWS_CLI cloudformation deploy \
  --stack-name online-bank-auth-service-stack \
  --template-file $ECS_TEMPLATE \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides ContainerImage=$FULL_IMAGE_NAME

echo "Create the ECS Fargate completed successfully."
