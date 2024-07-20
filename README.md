# Online Bank Platform Infrastructure

## Overview

This repository contains the infrastructure as code for the Online Bank Platform. It includes AWS CloudFormation templates and scripts to deploy and manage the infrastructure components such as the Cognito User Pool and ECS Fargate services.

## Directory Structure


- `cloudformation/`: Contains CloudFormation templates for various AWS services.
  - `cognito/`: Template for Cognito User Pool.
  - `ecs/`: Template for ECS Fargate.
- `scripts/`: Contains shell scripts for deploying and validating the infrastructure.
  - `deploy-infra.sh`: Script to deploy the infrastructure.
  - `validate-templates.sh`: Script to validate CloudFormation templates.
- `README.md`: This file.
- `.gitignore`: Defines files and directories to be ignored by Git.

## Prerequisites

- [AWS CLI](https://aws.amazon.com/cli/)
- [Docker](https://www.docker.com/)
- Appropriate AWS IAM permissions to create and manage the resources.

## Usage

### Validate Templates

Before deploying, you can validate the CloudFormation templates to ensure they are correct.

```bash
cd scripts
./validate-templates.sh