# dev-workflow-script


A simple bash script to manage development workflow managed with TMUX and NEOVIM. Tested on Manjaro

`dev` is a handy shell script to manage your development projects from the terminal — instantly open any project in a dedicated `tmux` session with `nvim`, initialize project scaffolds (Go, Node.js, Rust, etc.), and auto-run project setup scripts.

---

## 🚀 Features

- Jump into any project with:
  ```bash
  dev <project-name>

Smartly reuses existing tmux sessions

Interactive setup for:

    ✅ Git + README.md

    ✅ Go (go mod init)

    ✅ Rust (cargo init)

    ✅ JavaScript (npm init or yarn init)

    ✅ Blank project

Runs dev-start.sh if found in the project directory

Keeps your original shell free (tmux is launched separately)

Avoids multiple tmux windows per project

dev my-new-project

Follow the successive prompts
