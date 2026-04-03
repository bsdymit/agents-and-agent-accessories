---
name: terraform-config
description: "Use when: editing Terraform files for Lambda infrastructure; apply Terraform and AWS best practices"
applyTo: "**/terraform/**/*.tf"
---

# Terraform Configuration Instructions

Guidance for Terraform files managing AWS Lambda infrastructure.

## Apply To

- Files matching: `**/terraform/**/*.tf`
- When: Creating or editing Terraform infrastructure for Lambdas

## Guidance

### File Organization
- `main.tf` — Provider config, backend, Lambda resource
- `iam.tf` — IAM roles and policies
- `variables.tf` — Input variables with descriptions and defaults
- `outputs.tf` — Useful outputs (function ARN, API URL, etc.)
- Trigger-specific files: `api-gateway.tf`, `eventbridge.tf`, `sqs.tf`

### Naming
- Use `${var.project_name}-${var.environment}` pattern for resource names
- Use underscores in Terraform resource names: `aws_lambda_function.main`
- Use hyphens in AWS resource names: `my-project-dev`

### Tags
- Always set default tags via provider block
- Include: `Project`, `Environment`, `ManagedBy = "terraform"`

### Lambda Resources
- Pin runtime versions: `nodejs20.x`, `python3.12`
- Set reasonable defaults: `memory_size = 256`, `timeout = 30`
- Always create a CloudWatch log group with retention
- Use `source_code_hash` to trigger updates on code changes

### IAM
- Use least-privilege policies — never use `*` for resources unless truly needed
- Scope SSM access to `parameter/${var.project_name}/*`
- Use `aws_iam_policy_document` data sources for complex policies
- Attach `AWSLambdaBasicExecutionRole` for CloudWatch Logs access

### Variables
- Always add `description` to variables
- Use `default` values for non-sensitive, commonly-shared values
- Never set defaults for secrets or account-specific values
- Use `sensitive = true` for any secret variables

### State Management
- Use S3 backend with DynamoDB locking
- Key pattern: `{project-name}/terraform.tfstate`
