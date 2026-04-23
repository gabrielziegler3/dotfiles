#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Hyprland + Wayland Stack Setup (Ubuntu / Arch)
#
# CONTEXT FOR CLAUDE:
# Migrating from i3 (X11) to Hyprland (Wayland) on HP ZBook G8 laptop (Ubuntu).
# Hyprland config mirrors i3 keybindings (ALT+hjkl, ALT+d for rofi, etc).
# Theme: Tokyo Night across all components (hyprland, waybar, swaync, hyprlock).
#
# Dotfiles use GNU Stow. After installing packages, run:
#   cd ~/dotfiles && ./bootstrap.sh hyprland waybar swaync
# This symlinks configs from ~/dotfiles/{hyprland,waybar,swaync}/ into ~/.config/
#
# Stack: hyprland + waybar + swaync + hyprlock + hyprpaper + swaybg
# Dependencies: grim, slurp, wl-clipboard, cliphist, rofi, flameshot, wlogout
#
# On Ubuntu < 24.10: hyprland needs PPA or source build.
# hyprlock/hyprpaper/hyprpicker: likely need source build on Ubuntu.
# =============================================================================

echo "=== Hyprland + Wayland Stack Setup ==="
echo ""

# --- Detect package manager ---
if command -v pacman &>/dev/null; then
    PKG_MGR="pacman"
elif command -v apt &>/dev/null; then
    PKG_MGR="apt"
else
    echo "!! Unsupported package manager" >&2
    exit 1
fi

if [ "$PKG_MGR" = "apt" ]; then
    sudo apt-get update -qq

    # --- Hyprland ---
    UBUNTU_VER=$(lsb_release -rs 2>/dev/null || echo "0")
    echo "[1/4] Installing Hyprland (Ubuntu $UBUNTU_VER)..."

    if dpkg -l 2>/dev/null | grep -q "ii  hyprland "; then
        echo "  ✓ hyprland already installed"
    elif dpkg --compare-versions "$UBUNTU_VER" ge "24.10" 2>/dev/null; then
        sudo apt-get install -y hyprland
    else
        echo "  Adding Hyprland PPA..."
        sudo add-apt-repository -y ppa:hyprwm/hyprland 2>/dev/null || true
        sudo apt-get update -qq
        sudo apt-get install -y hyprland || {
            echo ""
            echo "  !! Hyprland PPA failed. Options:"
            echo "     1. Build from source: https://wiki.hyprland.org/Getting-Started/Installation/"
            echo "     2. Upgrade to Ubuntu 24.10+"
            echo ""
        }
    fi

    # --- Wayland dependencies ---
    echo ""
    echo "[2/4] Installing Wayland stack..."
    WAYLAND_PKGS=(
        waybar
        sway-notification-center
        grim slurp
        wl-clipboard cliphist
        swaybg
        rofi
        flameshot wlogout
        playerctl pavucontrol
        network-manager-gnome
        libnotify-bin
        fonts-font-awesome
    )
    for pkg in "${WAYLAND_PKGS[@]}"; do
        if ! dpkg -l "$pkg" 2>/dev/null | grep -q ^ii; then
            echo "  Installing $pkg..."
            sudo apt-get install -y "$pkg" 2>/dev/null || echo "  !! $pkg not in repos — install manually"
        else
            echo "  ✓ $pkg"
        fi
    done

    # --- Hyprland extras (likely need source build on Ubuntu) ---
    echo ""
    echo "[3/4] Checking hyprland extras..."
    for tool in hyprlock hyprpaper hyprpicker; do
        if command -v "$tool" &>/dev/null; then
            echo "  ✓ $tool"
        else
            echo "  !! $tool — not in apt, build from source:"
            echo "     git clone https://github.com/hyprwm/$tool && cd $tool"
            echo "     cmake -B build && cmake --build build -j$(nproc)"
            echo "     sudo cmake --install build"
        fi
    done

elif [ "$PKG_MGR" = "pacman" ]; then
    echo "[1/4] Installing Hyprland + Wayland stack (pacman)..."
    PKGS=(
        hyprland waybar swaync
        hyprlock hyprpaper hyprpicker
        swaybg grim slurp
        wl-clipboard cliphist
        rofi-wayland flameshot wlogout
        playerctl pavucontrol
        network-manager-applet
        ttf-font-awesome
    )
    sudo pacman -S --needed --noconfirm "${PKGS[@]}"
    echo "  ✓ All packages installed"
fi

# --- Stow configs ---
echo ""
echo "[4/4] Applying dotfiles configs..."
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
if [ -d "$DOTFILES_DIR" ] && [ -f "$DOTFILES_DIR/bootstrap.sh" ]; then
    cd "$DOTFILES_DIR"
    ./bootstrap.sh hyprland waybar swaync rofi
    echo "  ✓ Configs symlinked"
else
    echo "  !! ~/dotfiles not found. Clone it first:"
    echo "     git clone git@github.com:gabrielziegler3/dotfiles.git ~/dotfiles"
fi

echo ""
echo "=== Done ==="
echo ""
echo "Next steps:"
echo "  1. Copy wallpapers: scp desktop:~/Pictures/Wallpapers/ ~/Pictures/Wallpapers/"
echo "  2. Install MesloLGS Nerd Font (for waybar):"
echo "     https://github.com/romkatv/powerlevel10k#manual-font-installation"
echo "  3. Select Hyprland as session at login screen (GDM/SDDM)"
echo "  4. If using GDM (Ubuntu default), it should auto-detect Hyprland"
echo "     Otherwise: sudo apt install sddm && sudo systemctl enable sddm"
echo ""
