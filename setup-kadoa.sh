#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Kadoa Development Environment Setup
#
# CONTEXT FOR CLAUDE:
# Kadoa is a web scraping platform. The main codebase is a Turbo monorepo at
# ~/kadoa/kadoa-backend with apps/*, packages/*, services/*/* workspaces.
#
# Stack:
#   - Node 22 (via nvm) + Bun 1.3.x (monorepo package manager)
#   - Python 3.12 + uv (Astral's fast package manager)
#   - Docker (for local services) + Wireguard (for proxy connectivity)
#   - TypeScript 5.9.x, Turbo for build orchestration
#
# Repos:
#   ~/kadoa/kadoa-backend  — main monorepo (APIs, workers, engine, dashboard)
#   ~/kadoa/kadoa-sdks     — SDK packages (Node, Python, Go, Ruby)
#   ~/kadoa/kadoa-cli      — CLI tool (@kadoa/cli)
#   ~/kadoa/kadoa-mcp      — MCP server for Claude integration
#
# Setup flow:
#   1. Install runtimes (nvm, bun, uv, docker)
#   2. Clone repos
#   3. Copy .env.local from desktop (has GCP secrets, NPM tokens)
#   4. make nuke-turbo → kadcli setup → ./start-kadoa.sh --quick
#
# Local ports: PUBLIC_API=12380, REALTIME_API=16656, SCRAPER_API=16968,
#   OBSERVER_API=13513, OPERATIONS_API=33344, MAPPING_API=25344,
#   EVENT_GATEWAY=3333, MINIO=9000, Dashboard=3000
#
# Login: http://127.0.0.1:3000 with test@kadoa.com / test
#
# SECRETS (.env.local) must be copied from desktop — contains:
#   NPM_TASKFORCESH_TOKEN, GCP_SA_B64, GOOGLE_APPLICATION_CREDENTIALS,
#   KADOA_NPM_TOKEN, and more. ~17KB file.
# =============================================================================

DESKTOP_IP="${DESKTOP_IP:-192.168.1.7}"
DESKTOP_USER="${DESKTOP_USER:-gabrielziegler}"

echo "=== Kadoa Dev Environment Setup ==="
echo ""

# --- Detect package manager ---
if command -v apt &>/dev/null; then
    PKG_MGR="apt"
elif command -v pacman &>/dev/null; then
    PKG_MGR="pacman"
fi

install_if_missing() {
    local cmd="$1" pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        echo "  Installing $pkg..."
        case "${PKG_MGR:-}" in
            apt)    sudo apt-get install -y "$pkg" ;;
            pacman) sudo pacman -S --noconfirm "$pkg" ;;
            *)      echo "  !! Install $pkg manually" ;;
        esac
    else
        echo "  ✓ $cmd"
    fi
}

# --- 1. Prerequisites ---
echo "[1/6] Prerequisites..."
[ "$PKG_MGR" = "apt" ] && sudo apt-get update -qq
install_if_missing git
install_if_missing curl
install_if_missing jq
install_if_missing wg wireguard-tools
install_if_missing bc

# Docker
if ! command -v docker &>/dev/null; then
    echo "  Installing docker..."
    case "$PKG_MGR" in
        apt)    sudo apt-get install -y docker.io docker-compose-v2 && sudo usermod -aG docker "$USER" ;;
        pacman) sudo pacman -S --noconfirm docker docker-compose ;;
    esac
    echo "  !! You may need to log out and back in for docker group to take effect"
else
    echo "  ✓ docker"
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
    echo "  Installing gh..."
    case "$PKG_MGR" in
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update -qq && sudo apt-get install -y gh
            ;;
        pacman) sudo pacman -S --noconfirm github-cli ;;
    esac
else
    echo "  ✓ gh"
fi

# --- 2. Node 22 (via nvm) ---
echo ""
echo "[2/6] Node.js 22..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if command -v nvm &>/dev/null; then
    nvm install 22 && nvm alias default 22
    echo "  ✓ Node $(node --version)"
else
    echo "  !! nvm not in PATH — restart shell, then: nvm install 22"
fi

# --- 3. Bun ---
echo ""
echo "[3/6] Bun..."
if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun" && export PATH="$BUN_INSTALL/bin:$PATH"
fi
echo "  ✓ Bun $(bun --version 2>/dev/null || echo 'installed — restart shell')"

# --- 4. uv (Python) ---
echo ""
echo "[4/6] uv (Python package manager)..."
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi
echo "  ✓ uv $(uv --version 2>/dev/null || echo 'installed — restart shell')"

# --- 5. Clone repos ---
echo ""
echo "[5/6] Cloning Kadoa repos..."
mkdir -p ~/kadoa
cd ~/kadoa
for repo in kadoa-backend kadoa-sdks kadoa-cli kadoa-mcp; do
    if [ ! -d "$repo" ]; then
        echo "  Cloning $repo..."
        git clone "git@github.com:kadoa-com/$repo.git" || echo "  !! Failed — check SSH keys / gh auth"
    else
        echo "  ✓ $repo exists"
    fi
done

# --- 6. Copy secrets from desktop ---
echo ""
echo "[6/6] Copying secrets from desktop ($DESKTOP_USER@$DESKTOP_IP)..."
if [ -f ~/kadoa/kadoa-backend/.env.local ]; then
    echo "  ✓ .env.local already exists"
else
    echo "  Copying .env.local from desktop..."
    scp "$DESKTOP_USER@$DESKTOP_IP:~/kadoa/kadoa-backend/.env.local" ~/kadoa/kadoa-backend/.env.local && \
        echo "  ✓ .env.local copied" || \
        echo "  !! scp failed — copy manually: scp $DESKTOP_USER@$DESKTOP_IP:~/kadoa/kadoa-backend/.env.local ~/kadoa/kadoa-backend/"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Start Docker:        sudo systemctl start docker"
echo "  2. Connect Wireguard:   sudo wg-quick up wg0"
echo "  3. Full install:        cd ~/kadoa/kadoa-backend && make nuke-turbo"
echo "  4. Setup test account:  kadcli setup && kadcli gen-test-org"
echo "  5. Start services:      ./start-kadoa.sh --quick"
echo "  6. Open dashboard:      http://127.0.0.1:3000 (test@kadoa.com / test)"
echo ""
echo "  If DESKTOP_IP is wrong, re-run with: DESKTOP_IP=x.x.x.x ./setup-kadoa.sh"
echo ""
