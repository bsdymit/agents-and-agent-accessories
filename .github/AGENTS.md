# Available Agents & Skills

Registry of all customizations in this repository. Designed to be symlinked into project repos via `scripts/symlink.sh`.

---

## Agents

| Agent | File | Use When |
|-------|------|----------|
| **Lambda Developer** | `agents/lambda-developer.agent.md` | Building Lambda handlers, debugging execution, optimizing cold starts |
| **API Integrator** | `agents/api-integrator.agent.md` | Google APIs, PCO API, OAuth2, service accounts, webhooks |
| **Project Planner** | `agents/project-planner.agent.md` | Architecture design, Terraform infrastructure, project scaffolding |
| **Sync Engine** | `agents/sync-engine.agent.md` | Bidirectional sync, conflict resolution, field mapping, idempotency |

---

## Skills

| Skill | File | Use For |
|-------|------|---------|
| **Lambda Scaffold** | `skills/lambda-scaffold/SKILL.md` | Scaffolding new Lambda projects (handler, Terraform, CI/CD templates) |
| **API Integration** | `skills/api-integration/SKILL.md` | REST API clients for Google & PCO (auth, pagination, rate limiting templates) |
| **Webhook Sync** | `skills/webhook-sync/SKILL.md` | Webhook-driven bidirectional sync (handlers, types, sync service, Terraform templates) |

---

## Prompts

| Prompt | File | Params |
|--------|------|--------|
| **New Lambda** | `prompts/new-lambda.prompt.md` | name, description, language, trigger |
| **PCO Endpoint** | `prompts/pco-endpoint.prompt.md` | product, resource, operations, language |
| **Google API Client** | `prompts/google-api-client.prompt.md` | api, operations, language, auth |
| **Add Tests** | `prompts/add-tests.prompt.md` | file, framework |
| **Webhook Handler** | `prompts/webhook-handler.prompt.md` | source, language, events |
| **Calendar Sync** | `prompts/calendar-sync.prompt.md` | language, conflict-strategy, async |

---

## Instructions (Auto-Applied by File Pattern)

| Instruction | File | Applies To |
|------------|------|------------|
| **Lambda Handler** | `instructions/lambda-handler.instructions.md` | `**/handlers/**/*.{ts,js,py}` |
| **API Client** | `instructions/api-client.instructions.md` | `**/clients/**/*.{ts,js,py}` |
| **Terraform Config** | `instructions/terraform-config.instructions.md` | `**/terraform/**/*.tf` |
| **Webhook Handler** | `instructions/webhook-handler.instructions.md` | `**/handlers/**/*webhook*.*`, `**/handlers/**/*hook*.*` |
| **Sync Service** | `instructions/sync-service.instructions.md` | `**/services/**/*sync*.*`, `**/services/**/*transform*.*`, `**/services/**/*map*.*` |

---

## Hooks

| Hook | File | Event | Purpose |
|------|------|-------|---------|
| **Validate Webhook Security** | `hooks/validate-webhook-security.json` | PostToolUse | Warns when webhook handlers lack signature verification |

---

## Workspace Instructions

- **File**: `copilot-instructions.md` — Always-on global conventions

---

## Setup

```bash
./scripts/symlink.sh /path/to/repo           # Link into a repo
./scripts/symlink.sh /path/to/repo --remove   # Remove links
./scripts/symlink.sh                           # Link globally (all workspaces)
```
