#!/bin/bash

# Paths to CloudFormation templates
COGNITO_TEMPLATE="../cloudformation/cognito/cognito-template.yaml"
ECS_TEMPLATE="../cloudformation/ecs/ecs-template.yaml"
PIPELINE_TEMPLATE="../cloudformation/pipeline/pipeline-template.yaml"

# AWS CLI path
AWS_CLI="/usr/local/bin/aws"

# Validate Cognito User Pool template
echo "Validating Cognito User Pool template..."
$AWS_CLI cloudformation validate-template --template-body file://$COGNITO_TEMPLATE

# Validate ECS Fargate template
echo "Validating ECS Fargate template..."
$AWS_CLI cloudformation validate-template --template-body file://$ECS_TEMPLATE

# Validate CodePipeline template
echo "Validating CodePipeline template..."
$AWS_CLI cloudformation validate-template --template-body file://$PIPELINE_TEMPLATE

echo "Validation completed successfully."