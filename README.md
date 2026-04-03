# Agents & Agent Accessories

A centralized repository for AI agents, skills, prompts, and instructions for GitHub Copilot. Designed to be **symlinked into your Lambda project repos** so you get consistent AI-assisted development across all projects.

**Primary use case**: AWS Lambda functions (TypeScript + Python) that integrate with Google Workspace APIs and Planning Center Online API.

## What's Included

### Agents
| Agent | Use When |
|-------|----------|
| **Lambda Developer** | Building Lambda handlers, debugging execution, optimizing cold starts |
| **API Integrator** | Working with Google APIs or Planning Center Online API |
| **Project Planner** | Planning new Lambda projects, designing architecture, Terraform setup |

### Skills (with templates)
| Skill | Use For |
|-------|---------|
| **Lambda Scaffold** | Scaffolding new projects (handler, Terraform, tests, CI/CD templates) |
| **API Integration** | Building reliable API clients (Google + PCO client templates in TS & Python) |

### Prompts
| Prompt | Use For |
|--------|---------|
| **New Lambda** | Quick-scaffold a complete new Lambda project |
| **PCO Endpoint** | Generate typed client code for a PCO API endpoint |
| **Google API Client** | Generate authenticated Google API client code |
| **Add Tests** | Generate unit tests for handlers or API clients |

### Instructions (auto-applied by file pattern)
| Instruction | Applies To |
|-------------|------------|
| **Lambda Handler** | `**/handlers/**/*.{ts,js,py}` |
| **API Client** | `**/clients/**/*.{ts,js,py}` |
| **Terraform Config** | `**/terraform/**/*.tf` |

## Symlink Setup

Link this repo's customizations into any project:

```bash
# Link into a project
./scripts/symlink.sh /path/to/your-lambda-project

# Remove symlinks
./scripts/symlink.sh /path/to/your-lambda-project --remove
```

This creates symlinks for `agents/`, `skills/`, `prompts/`, and `instructions/` inside the target repo's `.github/` folder.

After symlinking, restart VS Code in the target project — Copilot will discover the agents, skills, and prompts automatically.

### Example Workflow

```bash
# 1. Clone this repo
git clone <this-repo> ~/Developer/git/agents-and-agent-accessories

# 2. Create a new Lambda project
mkdir ~/Developer/git/pco-sync && cd ~/Developer/git/pco-sync
git init

# 3. Symlink the customizations
~/Developer/git/agents-and-agent-accessories/scripts/symlink.sh .

# 4. Open in VS Code — agents, skills, prompts are now available
code .
```
