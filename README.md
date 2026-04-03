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

## Setup

### Global Install (recommended)

Run the symlink script with no arguments to make everything available in **all** VS Code workspaces:

```bash
./scripts/symlink.sh
```

This symlinks agents, skills, prompts, and instructions into your VS Code user-level prompts folder. After restarting VS Code, they're available everywhere — no per-repo setup needed.

To remove:
```bash
./scripts/symlink.sh --remove
```

### Per-Repo Install

To link into a specific repo's `.github/` instead:

```bash
./scripts/symlink.sh /path/to/your-lambda-project
./scripts/symlink.sh /path/to/your-lambda-project --remove
```

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
