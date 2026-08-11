# 🚀 Terminal Aliases

> Life is short. Type less, do more.

A collection of time-saving terminal shortcuts for developers who value their most precious resources - ⌛ time and 🧠 willpower.

## Why Aliases?

As developers, we type the same long commands hundreds of times each day:

```
git status                 → gs
docker compose up          → dcu
terraform plan             → tp
```

**Result**: Less typing, more creating. Save minutes every day and preserve your mental willpower for problems that actually matter.

## Quick Setup

1. Clone this repository to your preferred location:

```bash
# Choose a location that works for you:
git clone https://github.com/araltiparmak/terminal-aliases.git PATH_TO_REPO

# Example:
# git clone https://github.com/araltiparmak/terminal-aliases.git ~/dev/terminal-aliases
```

2. Add to your shell config, replacing `PATH_TO_REPO` with your actual path:

**Zsh/Bash** (in `.zshrc`, `.bashrc`, or `.bash_profile`):

```bash
source PATH_TO_REPO/aliases

# Example:
# source ~/dev/terminal-aliases/aliases
```

## Available Categories

- **General**: Navigate directories, edit config files
- **Claude**: Launch Claude Code
- **Git**: Streamline your git workflow
- **Package Managers**: Run yarn/npm/bun/pnpm commands faster
- **Terraform / Terragrunt**: Infrastructure as code shortcuts
- **Docker**: Manage containers and images quickly
- **Java / Gradle**: Common JVM build commands
- **Special Functions**: `mc` (mkdir + cd), `ij` (open a folder in IntelliJ IDEA, defaults to `.`), `ua` (pull latest aliases and re-source), `bu` (update/upgrade/clean Homebrew)

## React Scaffolding (`cra`)

`cra <kebab-case-name>` scaffolds a new React + Vite + TS + Tailwind v4 project at `~/dev/<name>` using pnpm, wires up a `@/` import alias, pins a free dev-server port, and makes the initial commit.

**Requirements:**

- Node 24.x
- pnpm, pinned to major version 10 via corepack (handled automatically by the script)

```bash
cra my-new-app
```

See `scripts/cra.sh` for details, or run `cra --help`.

## 📜 License

MIT