---
name: new-lambda
description: "Use when: need to scaffold a new Lambda project from scratch; takes project name and description"
params:
  - name: name
    description: "Project name in kebab-case (e.g., pco-sync, calendar-webhook)"
  - name: description
    description: "Brief description of what this Lambda does"
  - name: language
    description: "TypeScript or Python"
  - name: trigger
    description: "How the Lambda is invoked (api-gateway, schedule, sqs, s3, eventbridge)"
---

# New Lambda Project

Scaffold a complete new AWS Lambda project with handler, Terraform, tests, and CI/CD.

## Input Parameters

- **name**: Project name in kebab-case
- **description**: What this Lambda does
- **language**: TypeScript or Python
- **trigger**: Event source type

## What It Does

Creates a full project structure:
1. Handler code with structured logging and error handling
2. Terraform config (Lambda, IAM, trigger, CloudWatch logs)
3. Test scaffolding with sample test
4. Package config (package.json or requirements.txt)
5. GitHub Actions deploy workflow
6. README with setup instructions
7. .gitignore

Use the `lambda-scaffold` skill templates as the basis for generated files.

## Tips

- Choose TypeScript for Google API integrations (better `googleapis` types)
- Choose Python for data processing or when using pandas/numpy
- For webhook receivers, use `api-gateway` trigger
- For periodic syncs, use `schedule` trigger
- For async processing, use `sqs` trigger
