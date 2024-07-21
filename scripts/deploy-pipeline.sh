#!/bin/bash

set -e

# Path to CloudFormation template
PIPELINE_TEMPLATE="../cloudformation/pipeline/pipeline-template.yaml"

# GitHub OAuth Token
GITHUB_TOKEN=$(aws ssm get-parameter --name "GitHubPAT" --with-decryption --query "Parameter.Value" --output text)

# AWS CLI path
AWS_CLI="/usr/local/bin/aws"

# Deploy the Pipeline stack
echo "Deploying Pipeline stack..."
$AWS_CLI cloudformation deploy \
  --stack-name online-bank-pipeline-stack \
  --template-file $PIPELINE_TEMPLATE \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    GitHubOwner=rafaelcmd \
    GitHubRepo=online-banking-platform-application \
    GitHubBranch=main \
    GitHubOAuthToken=$GITHUB_TOKEN \
    CodeBuildProjectName=OnlineBankPlatformInfrastructureBuild \
    ClusterName=online-bank-platform-cluster \
    ServiceName=online-bank-platform-service \
    ArtifactBucket=online-banking-platform-artifact-bucket

echo "Pipeline creation completed successfully."
