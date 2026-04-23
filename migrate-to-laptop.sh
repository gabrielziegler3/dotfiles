#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Laptop Migration — Base Setup (Ubuntu, HP ZBook G8)
#
# CONTEXT FOR CLAUDE ON THE LAPTOP:
# This script bootstraps core tools, dotfiles (GNU Stow), and Claude Code.
# For specific setups, run the dedicated scripts:
#   ./setup-hyprland.sh  — Hyprland + Wayland stack (replaces i3/X11)
#   ./setup-kadoa.sh     — Kadoa dev environment (Node, Bun, repos, secrets)
#
# Dotfiles use GNU Stow: each app is a directory mirroring $HOME.
#   cd ~/dotfiles && ./bootstrap.sh          # all packages
#   cd ~/dotfiles && ./bootstrap.sh hyprland  # single package
#   stow -D <pkg>                            # unlink a package
#
# Claude Code config: settings.json has permissions, hooks (desktop
# notifications via notify-send), custom statusline, and plugins
# (superpowers, context7, code-review, caveman, chrome-devtools-mcp,
# frontend-design). Plugins are installed inside claude.
#
# SECURE BOOT / GRUB (HP ZBook G8):
#   Dual boot Windows/Ubuntu. Fix: install shim-signed, reinstall grub-efi,
#   set Ubuntu first in efibootmgr. Disable BIOS beeps in F10 > Advanced.
#   See manual steps printed at end of this script.
# =============================================================================

echo "=== Laptop Base Migration ==="
echo ""

# --- Detect package manager ---
if command -v apt &>/dev/null; then
    PKG_MGR="apt"
    sudo apt-get update -qq
elif command -v pacman &>/dev/null; then
    PKG_MGR="pacman"
else
    echo "!! Unsupported package manager" >&2; exit 1
fi

install_if_missing() {
    local cmd="$1" pkg="${2:-$1}"
    if ! command -v "$cmd" &>/dev/null; then
        echo "  Installing $pkg..."
        case "$PKG_MGR" in
            apt)    sudo apt-get install -y "$pkg" ;;
            pacman) sudo pacman -S --noconfirm "$pkg" ;;
        esac
    else
        echo "  ✓ $cmd"
    fi
}

# --- 1. Core tools ---
echo "[1/4] Core tools..."
install_if_missing git
install_if_missing curl
install_if_missing jq
install_if_missing zsh
install_if_missing tmux
install_if_missing stow
install_if_missing bc
install_if_missing efibootmgr

# --- 2. Dotfiles ---
echo ""
echo "[2/4] Dotfiles (stow)..."
if [ ! -d "$HOME/dotfiles" ]; then
    git clone git@github.com:gabrielziegler3/dotfiles.git ~/dotfiles
else
    echo "  ✓ ~/dotfiles exists"
    cd ~/dotfiles && git pull --ff-only 2>/dev/null || true
fi
cd ~/dotfiles
./bootstrap.sh zsh bash tmux kitty nvim git scripts claude
echo "  ✓ Core dotfiles stowed"

# --- 3. Claude Code ---
echo ""
echo "[3/4] Claude Code..."

# Install nvm + node first (needed for npm install)
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if command -v nvm &>/dev/null; then
    nvm install 22 && nvm alias default 22
fi

if ! command -v claude &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
fi
echo "  ✓ Claude Code $(claude --version 2>/dev/null || echo 'installed — restart shell')"

# settings.json (machine-specific, not stowed)
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
    echo "  ✓ settings.json exists"
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

# --- 4. Summary ---
echo ""
echo "[4/4] Next scripts to run:"
echo "  cd ~/dotfiles"
echo "  ./setup-hyprland.sh   # Hyprland + Wayland stack"
echo "  ./setup-kadoa.sh      # Kadoa dev environment + secrets"
echo ""
echo "==========================================="
echo "  Manual steps:"
echo "==========================================="
echo ""
echo "  AUTHENTICATE:"
echo "    claude           # login"
echo "    gh auth login    # GitHub CLI"
echo "    gcloud auth login"
echo ""
echo "  CLAUDE PLUGINS (inside claude):"
echo "    /install-plugin superpowers@claude-plugins-official"
echo "    /install-plugin context7@claude-plugins-official"
echo "    /install-plugin code-review@claude-plugins-official"
echo "    /install-plugin frontend-design@claude-plugins-official"
echo "    /install-plugin caveman@caveman"
echo "    /install-plugin chrome-devtools-mcp@chrome-devtools-plugins"
echo ""
echo "  GRUB + SECURE BOOT (HP ZBook G8):"
echo "    sudo efibootmgr -v                    # check boot entries"
echo "    sudo apt install shim-signed grub-efi-amd64-signed"
echo "    sudo grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ubuntu"
echo "    sudo update-grub"
echo "    sudo efibootmgr -o XXXX,YYYY          # ubuntu entry first"
echo "    # Reboot into BIOS (F10):"
echo "    #   Security > Secure Boot Config > enable Secure Boot"
echo "    #   Boot Options > set 'ubuntu' first"
echo "    #   Advanced > Built-in Device Options > uncheck 'Power-on beep'"
echo ""
