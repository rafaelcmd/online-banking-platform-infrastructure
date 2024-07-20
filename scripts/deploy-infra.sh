#!/bin/bash

set -e

# Paths to CloudFormation templates
COGNITO_TEMPLATE="../cloudformation/cognito/cognito-template.yaml"
ECS_TEMPLATE="../cloudformation/ecs/ecs-template.yaml"

# AWS CLI path
AWS_CLI="/usr/local/bin/aws"

# Deploy the Cognito User Pool stack
echo "Deploying Cognito User Pool stack..."
$AWS_CLI cloudformation deploy \
    --stack-name cognito-user-pool \
    --template-file $COGNITO_TEMPLATE \
    --capabilities CAPABILITY_NAMED_IAM

# Get the User Pool Client ID from the stack output
echo "Retrieving User Pool Client ID..."
USER_POOL_CLIENT_ID=$($AWS_CLI cloudformation describe-stacks \
    --stack-name cognito-user-pool \
    --output text \
    --query 'Stacks[0].Outputs[?OutputKey==`UserPoolClientId`].OutputValue')

# Put USER_POOL_CLIENT_ID on Systems Manager Parameter Store
echo "Storing User Pool Client ID in SSM Parameter Store..."
$AWS_CLI ssm put-parameter --name "USER_POOL_CLIENT_ID" --value "$USER_POOL_CLIENT_ID" --type "String" --overwrite

echo "Create the Cognito User Pool completed successfully."

# Create the ECS Fargate stack
echo "Creating ECR repository and pushing Docker image..."

# Create ECR repository and capture the URI
REPO_URI=$($AWS_CLI ecr describe-repositories --repository-names online-bank-auth-service --region us-east-2 --query 'repositories[0].repositoryUri' --output text 2>/dev/null)

if [ -z "$REPO_URI" ]; then
    echo "ECR repository does not exist. Creating repository..."
    REPO_URI=$($AWS_CLI ecr create-repository --repository-name online-bank-auth-service --region us-east-2 --query 'repository.repositoryUri' --output text)
else
    echo "ECR repository already exists. Using existing repository URI."
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