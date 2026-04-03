#!/usr/bin/env bash
set -euo pipefail

# Symlink agents-and-agent-accessories into a target repo's .github/ directory.
# This allows VS Code / Copilot to discover agents, skills, prompts, and instructions
# from this central hub when working in any linked repo.
#
# Usage:
#   ./scripts/symlink.sh /path/to/target-repo
#   ./scripts/symlink.sh /path/to/target-repo --remove   # Remove symlinks
#
# What it does:
#   Creates symlinks for agents/, skills/, prompts/, and instructions/ directories
#   inside the target repo's .github/ folder, pointing back to this repo.
#   It will NOT overwrite existing directories (only symlinks or missing dirs).

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_GITHUB="$SOURCE_REPO/.github"

DIRS_TO_LINK=(agents skills prompts instructions)

usage() {
  echo "Usage: $0 <target-repo-path> [--remove]"
  echo ""
  echo "Examples:"
  echo "  $0 ~/Developer/git/my-lambda-project"
  echo "  $0 ~/Developer/git/my-lambda-project --remove"
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

TARGET_REPO="$(cd "$1" && pwd)"
REMOVE=false

if [[ "${2:-}" == "--remove" ]]; then
  REMOVE=true
fi

TARGET_GITHUB="$TARGET_REPO/.github"

if $REMOVE; then
  echo "Removing symlinks from $TARGET_GITHUB..."
  for dir in "${DIRS_TO_LINK[@]}"; do
    target="$TARGET_GITHUB/$dir"
    if [[ -L "$target" ]]; then
      rm "$target"
      echo "  ✓ Removed symlink: $dir"
    else
      echo "  - Skipped $dir (not a symlink)"
    fi
  done
  echo "Done."
  exit 0
fi

echo "Linking agents-and-agent-accessories into: $TARGET_REPO"
echo "Source: $SOURCE_GITHUB"
echo ""

# Ensure target .github/ exists
mkdir -p "$TARGET_GITHUB"

for dir in "${DIRS_TO_LINK[@]}"; do
  source="$SOURCE_GITHUB/$dir"
  target="$TARGET_GITHUB/$dir"

  if [[ -L "$target" ]]; then
    # Already a symlink — update it
    rm "$target"
    ln -s "$source" "$target"
    echo "  ✓ Updated symlink: $dir -> $source"
  elif [[ -d "$target" ]]; then
    echo "  ✗ Skipped $dir (real directory exists — move/remove it first)"
  else
    ln -s "$source" "$target"
    echo "  ✓ Created symlink: $dir -> $source"
  fi
done

# Copy copilot-instructions.md if it doesn't exist (don't symlink — repos may want their own)
COPILOT_INST="$TARGET_GITHUB/copilot-instructions.md"
if [[ ! -f "$COPILOT_INST" ]]; then
  echo ""
  echo "  ℹ No copilot-instructions.md in target repo."
  echo "    You may want to create one for repo-specific conventions."
fi

echo ""
echo "Done! Restart VS Code in $TARGET_REPO to pick up the linked customizations."
