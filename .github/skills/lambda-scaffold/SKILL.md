---
name: lambda-scaffold
description: "Use when: scaffolding a new Lambda project, creating project boilerplate, setting up a new TypeScript or Python Lambda with Terraform; helps with project initialization"
---

# Lambda Scaffold Skill

Scaffolds a complete AWS Lambda project with handler, Terraform infrastructure, tests, and CI/CD.

## Use When

- Starting a brand new Lambda project
- Need a consistent project template
- Setting up Terraform for Lambda deployment
- Want boilerplate for TypeScript or Python Lambda

## What It Does

Creates a ready-to-deploy Lambda project with:
- Handler code with structured logging
- Terraform configuration (Lambda, IAM, trigger)
- Test scaffolding
- GitHub Actions deploy workflow
- Proper .gitignore and README

## Steps

1. Determine language (TypeScript or Python) and trigger type
2. Create project directory structure
3. Generate handler from template
4. Generate Terraform files from templates
5. Set up package management (package.json or requirements.txt)
6. Create test scaffolding
7. Generate .gitignore, README, and CI/CD workflow

## Templates

### TypeScript Handler
Located in `templates/ts-handler.template`

### Python Handler
Located in `templates/py-handler.template`

### Terraform Lambda
Located in `templates/terraform-lambda.template`

### Terraform IAM
Located in `templates/terraform-iam.template`

### Terraform Variables
Located in `templates/terraform-variables.template`

### GitHub Actions Deploy
Located in `templates/github-actions-deploy.template`

### Package.json
Located in `templates/package-json.template`

### tsconfig.json
Located in `templates/tsconfig.template`

## Best Practices

- Always use `aws-lambda-powertools` for structured logging
- Store secrets in SSM Parameter Store, reference by name in env vars
- Use esbuild for TypeScript bundling (fast, tree-shakes)
- Pin runtime versions in Terraform (`nodejs20.x`, `python3.12`)
- Set reasonable defaults: 256MB memory, 30s timeout
- Include a dead letter queue for async invocations

## Common Issues

**Q: Lambda can't find my handler after bundling?**
A: Check the `handler` field in Terraform matches the built output path. For esbuild, the output is flat — use `main.handler` not `handlers/main.handler`.

**Q: Lambda times out calling external APIs?**
A: Default Lambda timeout is 3s. Set it to 30s+ for API calls. Also check VPC/NAT if Lambda is in a VPC.

**Q: How do I test locally?**
A: Use `aws-lambda-local` (TS) or `python-lambda-local` (Python) with sample event JSON files.
