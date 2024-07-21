#!/bin/bash

set -e

# Paths to scripts
VALIDATE_CLOUDFORMATION_TEMPLATES="validate-templates.sh"
RETRIEVE_TOKEN_CLONE_SCRIPT="retrieve-token-and-clone.sh"
COGNITO_SCRIPT="deploy-cognito.sh"
ECS_ECR_SCRIPT="deploy-ecs-ecr.sh"
PIPELINE_SCRIPT="deploy-pipeline.sh"

# Run the validate CloudFormation templates script
echo "Running validate CloudFormation templates script..."
chmod +x $VALIDATE_CLOUDFORMATION_TEMPLATES
./$VALIDATE_CLOUDFORMATION_TEMPLATES

# Run the retrieve token and clone script
echo "Running retrieve token and clone script..."
chmod +x $RETRIEVE_TOKEN_CLONE_SCRIPT
./$RETRIEVE_TOKEN_CLONE_SCRIPT

# Run the Cognito deployment script
echo "Running Cognito deployment script..."
chmod +x $COGNITO_SCRIPT
./$COGNITO_SCRIPT

# Run the ECS and ECR deployment script
echo "Running ECS and ECR deployment script..."
chmod +x $ECS_ECR_SCRIPT
./$ECS_ECR_SCRIPT

# Run the pipeline deployment script
echo "Running pipeline deployment script..."
chmod +x $PIPELINE_SCRIPT
./$PIPELINE_SCRIPT

echo "All deployments completed successfully."
