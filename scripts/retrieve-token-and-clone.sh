#!/bin/bash

# Retrieve the GitHub token from AWS Systems Manager Parameter Store
GITHUB_TOKEN=$(aws ssm get-parameter --name "GitHubPAT" --with-decryption --query "Parameter.Value" --output text)

# Check if the token retrieval was successful
if [ -z "$GITHUB_TOKEN" ]; then
  echo "Failed to retrieve GitHub token"
  exit 1
fi

# Clone a repository using the token
REPO_OWNER="rafaelcmd"
REPO_NAME="online-banking-platform-application"
BRANCH="main"

# Use the token to authenticate the git clone command
git clone https://${GITHUB_TOKEN}@github.com/${REPO_OWNER}/${REPO_NAME}.git -b ${BRANCH}

# Check if the clone was successful
if [ $? -ne 0 ]; then
  echo "Failed to clone repository"
  exit 1
fi

echo "Repository cloned successfully"
