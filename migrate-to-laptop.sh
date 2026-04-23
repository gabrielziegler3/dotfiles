#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Laptop Migration Script for Gabriel's Dev Environment
# Run this ON THE LAPTOP (Ubuntu, HP ZBook G8)
#
# CONTEXT FOR CLAUDE ON THE LAPTOP:
# This script was generated from Gabriel's desktop (Manjaro) to bootstrap
# his laptop with the same dev environment. Here's what it sets up:
#
# 1. DOTFILES: ~/dotfiles repo restructured to use GNU Stow (was manual cp).
#    Each app is a "stow package" directory mirroring $HOME. Run:
#      cd ~/dotfiles && ./bootstrap.sh          # all packages
#      cd ~/dotfiles && ./bootstrap.sh hyprland  # single package
#      stow -D <pkg>                            # unlink a package
#
# 2. WINDOW MANAGER: Migrating from i3 (X11) to Hyprland (Wayland).
#    Hyprland config mirrors i3 keybindings (ALT+hjkl, ALT+d for rofi, etc).
#    Wayland stack: hyprland + waybar + swaync + hyprlock + hyprpaper + swaybg
#    Theme: Tokyo Night across all components.
#
# 3. DEV ENVIRONMENT (for Kadoa — web scraping platform):
#    - Node 22 (via nvm) + Bun 1.3.x (monorepo package manager)
#    - Python 3.12 + uv (Astral's package manager)
#    - Docker + Wireguard (for proxy in local dev)
#    - Kadoa is a Turbo monorepo at ~/kadoa/kadoa-backend
#    - Setup: make nuke-turbo → kadcli setup → ./start-kadoa.sh --quick
#    - Secrets in .env.local (scp from desktop)
#
# 4. CLAUDE CODE: Full config with permissions, hooks (desktop notifications),
#    custom statusline, plugins (superpowers, context7, code-review, caveman,
#    chrome-devtools-mcp, frontend-design). Plugins must be installed manually
#    inside claude via /install-plugin commands listed at the end.
#
# 5. SECURE BOOT / GRUB (HP ZBook G8):
#    Laptop has dual boot Windows/Ubuntu. Secure Boot makes it skip GRUB.
#    Fix: install shim-signed, reinstall grub-efi, set Ubuntu first in
#    efibootmgr. Also disable BIOS beeps in F10 > Advanced > Built-in Devices.
#
# TROUBLESHOOTING:
# - If hyprland isn't in apt repos: need PPA (ppa:hyprwm/hyprland) or
#   source build. Ubuntu 24.10+ should have it.
# - hyprlock/hyprpaper/hyprpicker: likely need source build on Ubuntu.
# - If stow conflicts: run stow --adopt <pkg> to pull existing files
#   into the dotfiles repo, then git diff to review.
# - Kadoa .env.local must be scp'd from desktop — contains GCP secrets.
# =============================================================================

echo "=== Gabriel's Laptop Migration ==="
echo ""

# --- Detect OS ---
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v pacman &>/dev/null; then PKG_MGR="pacman"
    elif command -v apt &>/dev/null; then PKG_MGR="apt"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PKG_MGR="brew"
fi

install_if_missing() {
    local cmd="$1" pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        echo "  Installing $pkg..."
        case "${PKG_MGR:-}" in
            pacman) sudo pacman -S --noconfirm "$pkg" ;;
            apt)    sudo apt-get install -y "$pkg" ;;
            brew)   brew install "$pkg" ;;
            *)      echo "  !! Can't auto-install $pkg — install manually" ;;
        esac
    else
        echo "  ✓ $cmd"
    fi
}

# --- 1. Core tools ---
echo "[1/8] Core tools..."
if [ "$PKG_MGR" = "apt" ]; then
    sudo apt-get update -qq
fi
install_if_missing git
install_if_missing curl
install_if_missing jq
install_if_missing zsh
install_if_missing tmux
install_if_missing stow
install_if_missing wg wireguard-tools
install_if_missing bc
install_if_missing pip3 python3-pip
install_if_missing efibootmgr

# Docker — apt needs docker.io, pacman needs docker
if ! command -v docker &>/dev/null; then
    case "$PKG_MGR" in
        apt)    sudo apt-get install -y docker.io docker-compose-v2 && sudo usermod -aG docker "$USER" ;;
        pacman) sudo pacman -S --noconfirm docker docker-compose ;;
        *)      echo "  !! Install Docker manually" ;;
    esac
else
    echo "  ✓ docker"
fi

# GitHub CLI
if ! command -v gh &>/dev/null; then
    case "$PKG_MGR" in
        apt)
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update -qq && sudo apt-get install -y gh
            ;;
        pacman) sudo pacman -S --noconfirm github-cli ;;
    esac
else
    echo "  ✓ gh"
fi

# --- 2. Hyprland + Wayland stack ---
echo ""
echo "[2/8] Hyprland + Wayland stack..."

if [ "$PKG_MGR" = "apt" ]; then
    # Ubuntu: Hyprland needs a PPA or source build
    # Check Ubuntu version — 24.10+ has hyprland in universe
    UBUNTU_VER=$(lsb_release -rs 2>/dev/null || echo "0")
    if dpkg -l | grep -q hyprland 2>/dev/null; then
        echo "  ✓ hyprland already installed"
    elif dpkg --compare-versions "$UBUNTU_VER" ge "24.10" 2>/dev/null; then
        echo "  Installing hyprland from Ubuntu repos..."
        sudo apt-get install -y hyprland
    else
        echo "  Adding Hyprland PPA for Ubuntu $UBUNTU_VER..."
        sudo add-apt-repository -y ppa:hyprwm/hyprland 2>/dev/null || true
        sudo apt-get update -qq
        sudo apt-get install -y hyprland || {
            echo "  !! Hyprland PPA failed. Manual install needed:"
            echo "     See: https://wiki.hyprland.org/Getting-Started/Installation/"
        }
    fi

    # Ubuntu package names for Wayland stack
    WAYLAND_PKGS=(
        waybar
        sway-notification-center
        grim
        slurp
        wl-clipboard
        cliphist
        flameshot
        wlogout
        swaybg
        rofi
        playerctl
        pavucontrol
        network-manager-gnome
        libnotify-bin
    )
    for pkg in "${WAYLAND_PKGS[@]}"; do
        if ! dpkg -l "$pkg" 2>/dev/null | grep -q ^ii; then
            echo "  Installing $pkg..."
            sudo apt-get install -y "$pkg" 2>/dev/null || echo "  !! $pkg not found in repos"
        else
            echo "  ✓ $pkg"
        fi
    done

    # These may need manual install on Ubuntu
    for tool in hyprlock hyprpaper hyprpicker; do
        if ! command -v "$tool" &>/dev/null; then
            echo "  !! $tool — not in apt repos, install from source:"
            echo "     https://github.com/hyprwm/$tool"
        else
            echo "  ✓ $tool"
        fi
    done

elif [ "$PKG_MGR" = "pacman" ]; then
    HYPR_PKGS=(hyprland waybar swaync hyprlock hyprpaper swaybg grim slurp wl-clipboard cliphist rofi-wayland flameshot hyprpicker wlogout playerctl pavucontrol network-manager-applet)
    for pkg in "${HYPR_PKGS[@]}"; do
        install_if_missing "$pkg"
    done
fi

# --- 3. Node (via nvm) ---
echo ""
echo "[3/8] Node.js 22 via nvm..."
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

# --- 4. Bun ---
echo ""
echo "[4/8] Bun..."
if ! command -v bun &>/dev/null; then
    curl -fsSL https://bun.sh/install | bash
    export BUN_INSTALL="$HOME/.bun" && export PATH="$BUN_INSTALL/bin:$PATH"
fi
echo "  ✓ Bun $(bun --version 2>/dev/null || echo 'installed — restart shell')"

# --- 5. uv (Python) ---
echo ""
echo "[5/8] uv (Python)..."
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
fi
echo "  ✓ uv $(uv --version 2>/dev/null || echo 'installed — restart shell')"

# --- 6. Claude Code ---
echo ""
echo "[6/8] Claude Code..."
if ! command -v claude &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
fi
echo "  ✓ Claude Code $(claude --version 2>/dev/null || echo 'installed')"

# --- 7. Dotfiles (stow-based) ---
echo ""
echo "[7/8] Dotfiles..."
if [ ! -d "$HOME/dotfiles" ]; then
    git clone git@github.com:gabrielziegler3/dotfiles.git ~/dotfiles
fi
cd ~/dotfiles
./bootstrap.sh zsh tmux kitty nvim git rofi scripts hyprland waybar swaync claude
echo "  ✓ Dotfiles stowed"

# --- 8. Claude Code extra config ---
echo ""
echo "[8/8] Claude Code settings.json..."
# settings.json goes to ~/.claude/ (not managed by stow since it contains machine-specific perms)
mkdir -p ~/.claude
if [ ! -f ~/.claude/settings.json ]; then
    cat > ~/.claude/settings.json << 'SETTINGS_EOF'
{
  "attribution": {
    "commit": "Co-Authored-By: WOZCODE <contact@withwoz.com>",
    "pr": "🧙 Built with [WOZCODE](https://wozcode.com)"
  },
  "permissions": {
    "allow": [
      "Bash",
      "Bash(mkdir:*)", "Bash(ls:*)", "Bash(cat:*)", "Bash(tree:*)",
      "Bash(pwd:*)", "Bash(head:*)", "Bash(tail:*)", "Bash(wc:*)",
      "Bash(sort:*)", "Bash(uniq:*)", "Bash(cut:*)", "Bash(file:*)",
      "Bash(stat:*)", "Bash(which:*)", "Bash(whereis:*)", "Bash(type:*)",
      "Bash(echo:*)", "Bash(basename:*)", "Bash(dirname:*)",
      "Bash(realpath:*)", "Bash(readlink:*)", "Bash(diff:*)",
      "Bash(env:*)", "Bash(printenv:*)", "Bash(uname:*)",
      "Bash(whoami:*)", "Bash(id:*)", "Bash(date:*)",
      "Bash(df:*)", "Bash(du:*)", "Bash(free:*)", "Bash(uptime:*)",
      "Bash(ps:*)", "Bash(top:*)", "Bash(htop:*)", "Bash(lsof:*)",
      "Bash(find:*)", "Bash(grep:*)", "Bash(rg:*)", "Bash(fd:*)",
      "Bash(fzf:*)", "Bash(xargs:*)",
      "Bash(git status:*)", "Bash(git diff:*)", "Bash(git log:*)",
      "Bash(git show:*)", "Bash(git branch:*)", "Bash(git tag:*)",
      "Bash(git remote:*)", "Bash(git stash list:*)",
      "Bash(git rev-parse:*)", "Bash(git config --list:*)",
      "Bash(git config --get:*)", "Bash(git blame:*)",
      "Bash(git shortlog:*)", "Bash(git ls-files:*)",
      "Bash(git ls-tree:*)", "Bash(git describe:*)",
      "Bash(git reflog:*)", "Bash(git cherry:*)",
      "Bash(git worktree list:*)", "Bash(git name-rev:*)",
      "Bash(git merge-base:*)", "Bash(git cat-file:*)",
      "Bash(git count-objects:*)",
      "Bash(gh pr:*)", "Bash(gh issue:*)", "Bash(gh repo view:*)",
      "Bash(gh api:*)", "Bash(gh run:*)", "Bash(gh auth status:*)",
      "Bash(docker ps:*)", "Bash(docker images:*)",
      "Bash(docker inspect:*)", "Bash(docker logs:*)",
      "Bash(docker stats:*)", "Bash(docker top:*)",
      "Bash(docker port:*)", "Bash(docker network ls:*)",
      "Bash(docker network inspect:*)", "Bash(docker volume ls:*)",
      "Bash(docker volume inspect:*)", "Bash(docker info:*)",
      "Bash(docker version:*)", "Bash(docker compose ps:*)",
      "Bash(docker compose logs:*)", "Bash(docker compose config:*)",
      "Bash(docker compose ls:*)", "Bash(docker container ls:*)",
      "Bash(docker container inspect:*)", "Bash(docker image ls:*)",
      "Bash(docker image inspect:*)", "Bash(docker system df:*)",
      "Bash(python --version:*)", "Bash(python3 --version:*)",
      "Bash(pip list:*)", "Bash(pip show:*)", "Bash(pip freeze:*)",
      "Bash(node --version:*)", "Bash(npm list:*)", "Bash(npm --version:*)",
      "Bash(jq:*)", "Bash(yq:*)", "Bash(sed:*)", "Bash(awk:*)",
      "Bash(cd:*)", "Bash(claude:*)", "Bash(chmod +x:*)",
      "Read", "Glob", "Grep", "WebSearch"
    ],
    "additionalDirectories": []
  },
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.message // \"Needs your attention\"' | xargs -I{} notify-send -i dialog-information -u normal 'Claude Code' '{}'"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "notify-send -i dialog-information -u low 'Claude Code' 'Response complete'"
          }
        ]
      }
    ]
  },
  "statusLine": {
    "type": "command",
    "command": "bash ~/.claude/statusline-command.sh"
  },
  "enabledPlugins": {
    "frontend-design@claude-plugins-official": true,
    "superpowers@claude-plugins-official": true,
    "context7@claude-plugins-official": true,
    "code-review@claude-plugins-official": true,
    "caveman@caveman": true,
    "chrome-devtools-mcp@chrome-devtools-plugins": true
  },
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": { "source": "github", "repo": "anthropics/claude-code" }
    },
    "caveman": {
      "source": { "source": "github", "repo": "JuliusBrussee/caveman" }
    },
    "chrome-devtools-plugins": {
      "source": { "source": "github", "repo": "ChromeDevTools/chrome-devtools-mcp" }
    }
  },
  "effortLevel": "medium"
}
SETTINGS_EOF
    echo "  ✓ settings.json written"
else
    echo "  ✓ settings.json already exists"
fi

# Statusline script
cat > ~/.claude/statusline-command.sh << 'SL_EOF'
#!/usr/bin/env bash
input=$(cat)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
model=$(echo "$input" | jq -r '.model.display_name // ""')
session=$(echo "$input" | jq -r '.session_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
rate_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
short_cwd="${cwd/#$HOME/\~}"
branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null \
         || GIT_OPTIONAL_LOCKS=0 git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fmt_tokens() {
  local n="$1"
  if [ -z "$n" ] || [ "$n" = "null" ]; then echo ""; return; fi
  if [ "$n" -ge 1000000 ] 2>/dev/null; then printf "%.1fM" "$(echo "scale=1; $n / 1000000" | bc)"
  elif [ "$n" -ge 1000 ] 2>/dev/null; then printf "%.1fk" "$(echo "scale=1; $n / 1000" | bc)"
  else echo "$n"; fi
}
parts=()
parts+=("\033[0;36m${short_cwd}\033[0m")
[ -n "$branch" ] && parts+=("\033[0;32m ${branch}\033[0m")
[ -n "$session" ] && parts+=("\033[0;35m\"${session}\"\033[0m")
[ -n "$model" ] && parts+=("\033[0;33m${model}\033[0m")
if [ -n "$used" ] && [ -n "$remaining" ]; then
  used_int=${used%.*}
  if [ "$used_int" -ge 80 ] 2>/dev/null; then c="\033[0;31m"
  elif [ "$used_int" -ge 50 ] 2>/dev/null; then c="\033[0;33m"
  else c="\033[2m"; fi
  parts+=("${c}ctx ${used_int}% used\033[0m")
fi
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  in_fmt=$(fmt_tokens "$total_in"); out_fmt=$(fmt_tokens "$total_out")
  [ -n "$in_fmt" ] && [ -n "$out_fmt" ] && parts+=("\033[2mtok in:${in_fmt} out:${out_fmt}\033[0m")
fi
rp=""
if [ -n "$rate_5h" ]; then
  r=$(printf "%.0f" "$rate_5h")
  [ "$r" -ge 80 ] 2>/dev/null && rp="${rp}\033[0;31m5h:${r}%\033[0m" || rp="${rp}\033[2m5h:${r}%\033[0m"
fi
if [ -n "$rate_7d" ]; then
  r=$(printf "%.0f" "$rate_7d")
  [ -n "$rp" ] && rp="${rp} "
  [ "$r" -ge 80 ] 2>/dev/null && rp="${rp}\033[0;31m7d:${r}%\033[0m" || rp="${rp}\033[2m7d:${r}%\033[0m"
fi
[ -n "$rp" ] && parts+=("${rp}")
sep=" \033[2m|\033[0m "; result=""
for p in "${parts[@]}"; do [ -z "$result" ] && result="$p" || result="${result}${sep}${p}"; done
printf "%b\n" "$result"
SL_EOF
chmod +x ~/.claude/statusline-command.sh

echo ""
echo "==========================================="
echo "  MIGRATION COMPLETE — Manual steps left:"
echo "==========================================="
echo ""
echo "  1. FIX GRUB + SECURE BOOT (HP ZBook G8):"
echo "     # Check current boot entries:"
echo "     sudo efibootmgr -v"
echo "     # Reinstall GRUB for UEFI + Secure Boot:"
echo "     sudo apt install shim-signed grub-efi-amd64-signed"
echo "     sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu"
echo "     sudo update-grub"
echo "     # Set Ubuntu/GRUB as first boot entry:"
echo "     sudo efibootmgr -o XXXX,YYYY   # (put ubuntu entry first)"
echo "     # Then reboot into BIOS (F10):"
echo "     #   - Security > Secure Boot Config > enable Secure Boot"
echo "     #   - Boot Options > set 'ubuntu' as first"
echo "     #   - Advanced > Built-in Device Options > uncheck 'Power-on beep'"
echo ""
echo "  2. DISABLE HP BIOS BEEPS:"
echo "     # F10 at boot > Advanced > Built-in Device Options"
echo "     #   > uncheck 'Power-on beep'"
echo "     # Also: Advanced > Boot Options > disable 'Audio alerts during boot'"
echo ""
echo "  3. AUTHENTICATE:"
echo "     claude          # login"
echo "     gh auth login   # GitHub CLI"
echo "     gcloud auth login"
echo ""
echo "  4. INSTALL CLAUDE PLUGINS (inside claude):"
echo "     /install-plugin superpowers@claude-plugins-official"
echo "     /install-plugin context7@claude-plugins-official"
echo "     /install-plugin code-review@claude-plugins-official"
echo "     /install-plugin frontend-design@claude-plugins-official"
echo "     /install-plugin caveman@caveman"
echo "     /install-plugin chrome-devtools-mcp@chrome-devtools-plugins"
echo ""
echo "  5. CLONE KADOA REPOS:"
echo "     mkdir -p ~/kadoa && cd ~/kadoa"
echo "     git clone git@github.com:kadoa-com/kadoa-backend.git"
echo "     git clone git@github.com:kadoa-com/kadoa-sdks.git"
echo "     git clone git@github.com:kadoa-com/kadoa-cli.git"
echo "     git clone git@github.com:kadoa-com/kadoa-mcp.git"
echo ""
echo "  6. KADOA SETUP:"
echo "     scp desktop:~/kadoa/kadoa-backend/.env.local ~/kadoa/kadoa-backend/"
echo "     cd ~/kadoa/kadoa-backend && make nuke-turbo"
echo "     kadcli setup && ./start-kadoa.sh --quick"
echo ""
echo "  7. WIREGUARD: copy config for proxy connectivity"
echo ""
echo "  8. WALLPAPER: copy ~/Pictures/Wallpapers/ for hyprpaper/swaybg"
echo ""
echo "  9. HYPRLAND EXTRAS (if not in Ubuntu repos):"
echo "     # hyprlock, hyprpaper, hyprpicker — build from source:"
echo "     # https://github.com/hyprwm/hyprlock"
echo "     # https://github.com/hyprwm/hyprpaper"
echo "     # https://github.com/hyprwm/hyprpicker"
echo ""
