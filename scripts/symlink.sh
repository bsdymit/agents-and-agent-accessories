#!/usr/bin/env bash
set -euo pipefail

# Symlink agents-and-agent-accessories so VS Code / Copilot discovers
# agents, skills, prompts, and instructions automatically.
#
# Usage:
#   ./scripts/symlink.sh                          # Global: link into VS Code user-level prompts
#   ./scripts/symlink.sh --remove                 # Global: remove user-level symlinks
#   ./scripts/symlink.sh /path/to/target-repo     # Per-repo: link into target .github/
#   ./scripts/symlink.sh /path/to/target-repo --remove
#
# Global mode (no path argument):
#   Links agents/, skills/, prompts/, instructions/ into the VS Code user
#   prompts folder so they are available in ALL workspaces automatically.
#
# Per-repo mode (with path argument):
#   Links into a specific repo's .github/ folder.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_REPO="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_GITHUB="$SOURCE_REPO/.github"

DIRS_TO_LINK=(agents skills prompts instructions hooks)

# Detect VS Code user prompts folder
detect_vscode_prompts_dir() {
  local candidates=(
    "$HOME/Library/Application Support/Code/User/prompts"           # macOS - VS Code
    "$HOME/Library/Application Support/Code - Insiders/User/prompts" # macOS - Insiders
    "$HOME/.config/Code/User/prompts"                                # Linux - VS Code
    "$HOME/.config/Code - Insiders/User/prompts"                     # Linux - Insiders
  )
  if [[ -n "${APPDATA:-}" ]]; then
    candidates+=("$APPDATA/Code/User/prompts")                       # Windows (Git Bash)
  fi
  for dir in "${candidates[@]}"; do
    # Check if the parent (User/) exists — prompts/ may not yet
    local parent
    parent="$(dirname "$dir")"
    if [[ -d "$parent" ]]; then
      echo "$dir"
      return 0
    fi
  done
  return 1
}

usage() {
  echo "Usage: $0 [target-repo-path] [--remove]"
  echo ""
  echo "Global (recommended — available in all workspaces):"
  echo "  $0                    Link into VS Code user prompts folder"
  echo "  $0 --remove           Remove global symlinks"
  echo ""
  echo "Per-repo:"
  echo "  $0 /path/to/repo      Link into a specific repo's .github/"
  echo "  $0 /path/to/repo --remove"
  exit 1
}

# --- Determine mode ---
REMOVE=false
TARGET_PATH=""

for arg in "$@"; do
  if [[ "$arg" == "--remove" ]]; then
    REMOVE=true
  elif [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
    usage
  else
    TARGET_PATH="$arg"
  fi
done

# --- Global mode (no target path) ---
if [[ -z "$TARGET_PATH" ]]; then
  VSCODE_DIR=$(detect_vscode_prompts_dir) || {
    echo "Error: Could not find VS Code user data directory."
    echo "Provide a target repo path instead: $0 /path/to/repo"
    exit 1
  }

  if $REMOVE; then
    echo "Removing global symlinks from: $VSCODE_DIR"
    for dir in "${DIRS_TO_LINK[@]}"; do
      target="$VSCODE_DIR/$dir"
      if [[ -L "$target" ]]; then
        rm "$target"
        echo "  ✓ Removed symlink: $dir"
      else
        echo "  - Skipped $dir (not a symlink)"
      fi
    done
    echo "Done. Restart VS Code to apply."
    exit 0
  fi

  echo "Linking agents-and-agent-accessories into VS Code (global):"
  echo "  Source: $SOURCE_GITHUB"
  echo "  Target: $VSCODE_DIR"
  echo ""

  mkdir -p "$VSCODE_DIR"

  for dir in "${DIRS_TO_LINK[@]}"; do
    source="$SOURCE_GITHUB/$dir"
    target="$VSCODE_DIR/$dir"

    if [[ -L "$target" ]]; then
      rm "$target"
      ln -s "$source" "$target"
      echo "  ✓ Updated symlink: $dir"
    elif [[ -d "$target" ]]; then
      echo "  ✗ Skipped $dir (real directory exists — move/remove it first)"
    else
      ln -s "$source" "$target"
      echo "  ✓ Created symlink: $dir"
    fi
  done

  echo ""
  echo "Done! Restart VS Code — agents, skills, prompts, and instructions"
  echo "are now available in every workspace."
  exit 0
fi

# --- Per-repo mode ---
TARGET_REPO="$(cd "$TARGET_PATH" && pwd)"
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
echo "  Source: $SOURCE_GITHUB"
echo ""

mkdir -p "$TARGET_GITHUB"

for dir in "${DIRS_TO_LINK[@]}"; do
  source="$SOURCE_GITHUB/$dir"
  target="$TARGET_GITHUB/$dir"

  if [[ -L "$target" ]]; then
    rm "$target"
    ln -s "$source" "$target"
    echo "  ✓ Updated symlink: $dir"
  elif [[ -d "$target" ]]; then
    echo "  ✗ Skipped $dir (real directory exists — move/remove it first)"
  else
    ln -s "$source" "$target"
    echo "  ✓ Created symlink: $dir"
  fi
done

COPILOT_INST="$TARGET_GITHUB/copilot-instructions.md"
if [[ ! -f "$COPILOT_INST" ]]; then
  echo ""
  echo "  ℹ No copilot-instructions.md in target repo."
  echo "    You may want to create one for repo-specific conventions."
fi

echo ""
echo "Done! Restart VS Code in $TARGET_REPO to pick up the linked customizations."
