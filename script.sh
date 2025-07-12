#!/bin/bash

DEV_DIR="$HOME/Documents/Dev"

if [ -z "$1" ]; then
  echo "Usage: dev <project-name>"
  exit 1
fi

PROJECT="$1"
PROJECT_PATH="$DEV_DIR/$PROJECT"
SESSION_NAME="dev-$PROJECT"

# ─────────────────────────────
# Step 1: Git + README
# ─────────────────────────────
if [ ! -d "$PROJECT_PATH" ]; then
  echo "Project '$PROJECT' does not exist. Creating..."
  mkdir -p "$PROJECT_PATH"
  cd "$PROJECT_PATH" || exit 1

  read -p "Initialize Git? [y/N]: " git_init
  [[ "$git_init" =~ ^[Yy]$ ]] && git init && echo "# $PROJECT" > README.md

  # ─────────────────────────────
  # Step 2: Language-specific Setup
  # ─────────────────────────────
  echo "Choose project type:"
  echo "1) Go"
  echo "2) Rust (cargo)"
  echo "3) JavaScript (npm)"
  echo "4) JavaScript (yarn)"
  echo "5) Just blank"
  read -p "Enter choice [1-5]: " choice

  case "$choice" in
    1)
      go mod init "$PROJECT"
      ;;
    2)
      cargo init
      ;;
    3)
      npm init -y
      ;;
    4)
      yarn init -y
      ;;
    5)
      echo "Starting blank project."
      ;;
    *)
      echo "Invalid choice. Starting blank."
      ;;
  esac
else
  cd "$PROJECT_PATH" || exit 1
fi

# ─────────────────────────────
# Step 3: Run setup script if found
# ─────────────────────────────
if [[ -x "$PROJECT_PATH/dev-start.sh" ]]; then
  echo "Running dev-start.sh ..."
  "$PROJECT_PATH/dev-start.sh"
fi

# ─────────────────────────────
# Step 4: Tmux + Nvim smart attach
# ─────────────────────────────

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  # First time: create session and launch nvim
  tmux new-session -s "$SESSION_NAME" -c "$PROJECT_PATH" -d 'nvim .'
  echo "Created new tmux session: $SESSION_NAME"
else
  # Session exists: check if a window for this project already exists
  if ! tmux list-windows -t "$SESSION_NAME" | grep -q "$PROJECT"; then
    tmux new-window -t "$SESSION_NAME" -c "$PROJECT_PATH" -n "$PROJECT" 'nvim .'
    echo "Opened new window in existing session: $PROJECT"
  else
    echo "Session '$SESSION_NAME' already running."
  fi
fi

if [ -z "$TMUX" ]; then
  tmux attach -t "$SESSION_NAME"
else
  echo "Use 'tmux attach -t $SESSION_NAME' to enter."
fi
