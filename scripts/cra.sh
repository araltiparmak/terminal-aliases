#!/usr/bin/env bash
# cra — React + Vite + TS + Tailwind v4 scaffolder (pnpm).
set -euo pipefail

NODE_MAJOR=24
PNPM_MAJOR=10

die() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }
step() { printf '\033[36m▸\033[0m %s\n' "$*"; }

NAME="${1:-}"
case "$NAME" in
  ''|-h|--help)
    cat <<USAGE
usage: cra <kebab-case-name>

Creates ~/dev/<name> as a React + Vite + TS + Tailwind v4 project:
  - free port pinned in vite.config.ts (strictPort)
  - @/ alias wired in BOTH vite.config.ts and tsconfig.app.json
  - Tailwind v4 via @tailwindcss/vite (no config file, no PostCSS)
  - initial git commit

Requires Node ${NODE_MAJOR}.x. pnpm is pinned to major ${PNPM_MAJOR} via corepack.
USAGE
    exit 0 ;;
esac

[[ "$NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || die "name must be kebab-case: '$NAME'"

DEST="$HOME/dev/$NAME"
[[ -e "$DEST" ]] && die "$DEST already exists"

NODE_V="$(node -v 2>/dev/null || true)"
[[ "$NODE_V" == v${NODE_MAJOR}.* ]] || die "Node ${NODE_MAJOR}.x required, found ${NODE_V:-none}"

step "pinning pnpm@${PNPM_MAJOR} via corepack"
corepack enable
corepack prepare "pnpm@${PNPM_MAJOR}" --activate

step "picking a free port"
PORT=""
for _ in $(seq 1 200); do
  P=$((RANDOM % 6000 + 4000))
  lsof -i :"$P" >/dev/null 2>&1 || { PORT=$P; break; }
done
[[ -n "$PORT" ]] || die "no free port found in 4000-9999"
echo "  port $PORT"

step "scaffolding $DEST"
mkdir -p "$DEST"
trap 'rm -rf "$DEST"' EXIT
cd "$DEST"
LOG="$(mktemp -t cra)"
pnpm create vite@latest . --template react-ts </dev/null >"$LOG" 2>&1 \
  || die "pnpm create vite failed — see $LOG"
pnpm install --silent || die "pnpm install failed"
pnpm add -d tailwindcss@latest @tailwindcss/vite@latest --silent \
  || die "installing tailwind failed"

step "wiring tailwind, @/ alias and port $PORT"
cat > vite.config.ts <<EOF
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'
import path from 'node:path'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  resolve: { alias: { '@': path.resolve(import.meta.dirname, './src') } },
  server: { port: $PORT, strictPort: true },
})
EOF

echo '@import "tailwindcss";' > src/index.css

# paths only — baseUrl is deprecated in TypeScript 6 and fails the build.
grep -q '"paths"' tsconfig.app.json \
  || sed -i '' 's|"compilerOptions": {|"compilerOptions": {\n    "paths": { "@/*": ["./src/*"] },|' tsconfig.app.json
grep -q '"paths"' tsconfig.app.json || die "failed to add paths to tsconfig.app.json"

rm -f src/App.css
mkdir -p src/components
cat > src/components/Proof.tsx <<'EOF'
export function Proof() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-950">
      <p className="rounded-lg bg-slate-800 px-6 py-4 text-xl font-semibold text-emerald-400">
        Tailwind + @/ alias OK
      </p>
    </div>
  )
}
EOF
cat > src/App.tsx <<'EOF'
import { Proof } from '@/components/Proof'

export default function App() {
  return <Proof />
}
EOF

step "bumping dependencies to latest"
pnpm up --latest --silent || die "pnpm up --latest failed"

step "committing"
git init -b main -q
git add -A
git commit -q -m "Scaffold React + Vite + TS + Tailwind project"
[[ -z "$(git status --porcelain)" ]] || die "working tree not clean after commit"
trap - EXIT

printf '\n\033[32m✓ ready\033[0m  %s\n' "$DEST"
printf '  dev server : \033[4mhttp://localhost:%s\033[0m  (pnpm dev)\n' "$PORT"
printf '  next       : replace src/components/Proof.tsx with the real thing\n'
