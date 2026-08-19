#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Dotfiles bootstrap — uses GNU Stow for symlink management
# Usage: ./bootstrap.sh [package ...]
#   No args = install all packages
#   With args = install only listed packages (e.g. ./bootstrap.sh zsh nvim hyprland)
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# All stow packages (directories that contain dotfiles)
ALL_PACKAGES=(
    zsh bash vim shell git tmux
    kitty nvim yazi
    i3 polybar dunst rofi picom ranger neofetch nemo
    hyprland waybar swaync
    scripts bin applications
)

# i3/X11 stack vs Hyprland/Wayland stack
I3_PACKAGES=(i3 polybar dunst picom)
HYPRLAND_PACKAGES=(hyprland waybar swaync)

# ── Helpers ──────────────────────────────────────────────────────
info()  { printf "\033[0;36m%s\033[0m\n" "$*"; }
ok()    { printf "\033[0;32m  ✓ %s\033[0m\n" "$*"; }
warn()  { printf "\033[0;33m  ⚠ %s\033[0m\n" "$*"; }

# ── Ensure stow is installed ────────────────────────────────────
if ! command -v stow &>/dev/null; then
    info "Installing stow..."
    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm stow
    elif command -v apt &>/dev/null; then
        sudo apt-get install -y stow
    elif command -v brew &>/dev/null; then
        brew install stow
    else
        echo "ERROR: Install GNU Stow manually" >&2
        exit 1
    fi
fi

# ── Determine packages to install ───────────────────────────────
# --adopt pulls conflicting files that already exist in $HOME into the repo,
# then symlinks them back. The live file wins; review `git diff` afterwards.
# --restow is deliberately dropped in adopt mode: its unstow phase treats the
# existing real files as conflicts and aborts before --adopt can claim them.
STOW_FLAGS=(--restow --no-folding)
if [ "${1:-}" = "--adopt" ]; then
    STOW_FLAGS=(--no-folding --adopt)
    shift
fi

if [ $# -gt 0 ]; then
    PACKAGES=("$@")
else
    PACKAGES=("${ALL_PACKAGES[@]}")
fi

# ── Stow each package ──────────────────────────────────────────
info "Stowing packages into $HOME..."
failed=()
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        # --restow: unlink then relink (safe for updates)
        # --no-folding: create dirs instead of symlinking dirs
        #   (prevents stow from symlinking entire .config/nvim/ dir,
        #    which would make new files created there land in dotfiles repo)
        # Errors are printed, not swallowed: silent conflict skips are why
        # packages could sit unlinked for months without anyone noticing.
        if stderr=$(stow "${STOW_FLAGS[@]}" --target="$HOME" "$pkg" 2>&1); then
            ok "$pkg"
        else
            failed+=("$pkg")
            warn "$pkg — not linked"
            printf '%s\n' "$stderr" | sed 's/^/      /'
            warn "  retry with: ./bootstrap.sh --adopt $pkg"
        fi
    else
        warn "$pkg — package directory not found, skipping"
    fi
done

echo ""
if ((${#failed[@]})); then
    warn "Failed: ${failed[*]}"
else
    info "Done! Installed: ${PACKAGES[*]}"
fi
echo ""
echo "Useful commands:"
echo "  stow --restow --no-folding <pkg>   # re-apply a package"
echo "  stow -D <pkg>                      # unlink a package"
echo "  ./bootstrap.sh --adopt <pkg>       # adopt existing $HOME files into repo"
