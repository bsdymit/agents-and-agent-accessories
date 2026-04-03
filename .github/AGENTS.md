# Available Agents & Skills

Registry of all custom agents, skills, prompts, and instructions in this repository. This repo is designed to be symlinked into other project repos via `scripts/symlink.sh`.

---

## Agents

### Lambda Developer
- **File**: `.github/agents/lambda-developer.agent.md`
- **Use when**: Building AWS Lambda functions, creating handlers, debugging Lambda execution, optimizing cold starts
- **Languages**: TypeScript, Python
- **Key Features**: Handler scaffolding, structured logging, error handling patterns, event source typing
- **Status**: active

### API Integrator
- **File**: `.github/agents/api-integrator.agent.md`
- **Use when**: Integrating with Google APIs (Sheets, Calendar, Drive, Admin, Gmail) or Planning Center Online API
- **Key Features**: OAuth2/service account auth, PCO pagination, rate limiting, webhook verification
- **Status**: active

### Project Planner
- **File**: `.github/agents/project-planner.agent.md`
- **Use when**: Planning new Lambda projects, designing architecture, setting up Terraform infrastructure
- **Key Features**: Project scaffolding, Terraform patterns, IAM policies, CI/CD setup
- **Status**: active

---

## Skills

### Lambda Scaffold
- **File**: `.github/skills/lambda-scaffold/SKILL.md`
- **Use for**: Scaffolding new Lambda projects with handler, Terraform, tests, and CI/CD
- **Includes**:
  - TypeScript and Python handler templates
  - Terraform templates (Lambda, IAM, variables)
  - GitHub Actions deploy workflow template
  - package.json and tsconfig.json templates
- **Status**: active

### API Integration
- **File**: `.github/skills/api-integration/SKILL.md`
- **Use for**: Building reliable REST API clients for Google and PCO APIs
- **Includes**:
  - Google API client templates (TypeScript + Python)
  - PCO API client templates (TypeScript + Python)
  - Pagination, rate limiting, and auth patterns
- **Status**: active

---

## Prompts

### New Lambda
- **File**: `.github/prompts/new-lambda.prompt.md`
- **Use for**: Quick-scaffolding a new Lambda project from scratch
- **Params**: name, description, language, trigger

### PCO Endpoint
- **File**: `.github/prompts/pco-endpoint.prompt.md`
- **Use for**: Generating typed client code for a specific PCO API endpoint
- **Params**: product, resource, operations, language

### Google API Client
- **File**: `.github/prompts/google-api-client.prompt.md`
- **Use for**: Generating authenticated Google API client code for Lambda
- **Params**: api, operations, language, auth

### Add Tests
- **File**: `.github/prompts/add-tests.prompt.md`
- **Use for**: Generating unit tests for handlers or API clients
- **Params**: file, framework

---

## Instructions (File-Scoped)

### Lambda Handler
- **File**: `.github/instructions/lambda-handler.instructions.md`
- **Applies to**: `**/handlers/**/*.{ts,js,py}`
- **Guidance**: Handler structure, error handling, logging, env vars

### API Client
- **File**: `.github/instructions/api-client.instructions.md`
- **Applies to**: `**/clients/**/*.{ts,js,py}`
- **Guidance**: Auth caching, HTTP best practices, pagination, error handling

### Terraform Config
- **File**: `.github/instructions/terraform-config.instructions.md`
- **Applies to**: `**/terraform/**/*.tf`
- **Guidance**: File organization, naming, tags, IAM least-privilege, state management

---

## Workspace Instructions

### Global Conventions
- **File**: `.github/copilot-instructions.md`
- **Applies to**: Everything in this workspace

---

## Setup

To link these customizations into another repo:
```bash
./scripts/symlink.sh /path/to/your-lambda-project
```

To remove:
```bash
./scripts/symlink.sh /path/to/your-lambda-project --remove
```
