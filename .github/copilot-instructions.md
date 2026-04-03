---
name: workspace-instructions
description: "Workspace conventions for AWS Lambda projects with Google and Planning Center Online API integrations"
---

# Workspace Instructions

Central hub for AI agents, skills, prompts, and instructions. This repo is designed to be symlinked into Lambda project repos so these customizations are available everywhere.

## Tech Stack

- **Languages**: TypeScript (Node.js 20) and Python 3.12
- **Runtime**: AWS Lambda
- **Infrastructure**: Terraform
- **Package Manager**: npm (TypeScript), pip (Python)
- **APIs**: Google Workspace APIs, Planning Center Online API
- **CI/CD**: GitHub Actions

## Project Conventions

### Code Structure
- `src/handlers/` — Lambda entry points (thin wrappers)
- `src/services/` — Business logic
- `src/clients/` — External API client wrappers (Google, PCO)
- `src/utils/` — Shared utilities
- `src/types/` — TypeScript type definitions

### Naming
- **Files**: kebab-case (`pco-people-client.ts`, `sync-service.py`)
- **Functions/methods**: camelCase (TS), snake_case (Python)
- **Classes**: PascalCase in both
- **Environment variables**: UPPER_SNAKE_CASE
- **Terraform resources**: snake_case

### Key Rules
- Use `aws-lambda-powertools` for structured logging
- Keep handlers thin — delegate to service modules
- Cache API credentials at module level (outside handler)
- Store secrets in AWS SSM Parameter Store, reference by env var name
- Always handle rate limiting (429) with exponential backoff
- Always paginate — never assume single-page responses
- Mock at the HTTP/SDK boundary in tests

## Available Customizations

Check `.github/AGENTS.md` for the full registry of agents, skills, prompts, and instructions.

## Symlink Setup

To use these customizations in another repo:
```bash
./scripts/symlink.sh /path/to/your-project
```
