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
    kitty nvim
    i3 polybar dunst rofi picom ranger neofetch
    hyprland waybar swaync
    scripts claude
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
if [ $# -gt 0 ]; then
    PACKAGES=("$@")
else
    PACKAGES=("${ALL_PACKAGES[@]}")
fi

# ── Stow each package ──────────────────────────────────────────
info "Stowing packages into $HOME..."
for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        # --restow: unlink then relink (safe for updates)
        # --no-folding: create dirs instead of symlinking dirs
        #   (prevents stow from symlinking entire .config/nvim/ dir,
        #    which would make new files created there land in dotfiles repo)
        stow --restow --no-folding --target="$HOME" "$pkg" 2>/dev/null && \
            ok "$pkg" || \
            warn "$pkg — conflicts exist, run: stow --restow --no-folding --adopt $pkg"
    else
        warn "$pkg — package directory not found, skipping"
    fi
done

echo ""
info "Done! Installed: ${PACKAGES[*]}"
echo ""
echo "Useful commands:"
echo "  stow --restow --no-folding <pkg>   # re-apply a package"
echo "  stow -D <pkg>                      # unlink a package"
echo "  stow --adopt <pkg>                 # adopt existing files into repo"
