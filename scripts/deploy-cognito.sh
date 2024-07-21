#!/bin/bash

set -e

# Paths to CloudFormation templates
COGNITO_TEMPLATE="../cloudformation/cognito/cognito-template.yaml"

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
