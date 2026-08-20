# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Quick start

```bash
git clone git@github.com:gabrielziegler3/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install everything
./bootstrap.sh

# Or pick specific packages
./bootstrap.sh zsh nvim yazi kitty tmux hyprland waybar swaync
```

## Packages

| Package | What it configures |
|---------|--------------------|
| `zsh` | .zshrc, Powerlevel10k |
| `bash` | .bashrc, .bash_aliases |
| `vim` | .vimrc |
| `shell` | .profile, .env_variables |
| `git` | .gitconfig |
| `tmux` | .tmux.conf, plugins |
| `kitty` | Terminal emulator |
| `nvim` | Neovim (Lua config) |
| `yazi` | Terminal file manager |
| `rofi` | App launcher |
| `ranger` | TUI file manager |
| `neofetch` | System info |
| **hyprland** | Hyprland WM (Wayland) |
| **waybar** | Status bar (Wayland) |
| **swaync** | Notification center (Wayland) |
| `scripts` | Helper scripts (~/.scripts) |
| `bin` | Executables (~/.local/bin) |
| `nemo` | File manager |
| `applications` | Desktop entries |

**Hyprland stack** (Wayland): `hyprland`, `waybar`, `swaync`

## Stow cheatsheet

```bash
stow --restow --no-folding <pkg>   # re-apply a package
stow -D <pkg>                      # unlink a package
./bootstrap.sh --adopt <pkg>       # adopt existing $HOME files into repo (then git diff to review)
```

## System

* OS: Ubuntu
* WM: Hyprland (Wayland)
* Terminal: kitty
* Shell: zsh + Powerlevel10k
* Editor: Neovim
* Launcher: Rofi

## Voice Dictation (Vocalinux)

Voice-to-text for CLI/terminal using [Vocalinux](https://github.com/jatinkrmalik/vocalinux) with whisper.cpp (Vulkan GPU backend).

**Install:**
```bash
curl -fsSL raw.githubusercontent.com/jatinkrmalik/vocalinux/v0.8.0-beta/install.sh -o /tmp/vl.sh && bash /tmp/vl.sh
```
Choose: whisper.cpp -> GPU (Vulkan) -> Download models now.

### Demo
![Demo](./figures/system-demo.gif)
