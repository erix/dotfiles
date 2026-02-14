# Chezmoi Dotfiles - Cross-Platform Setup

This repository manages dotfiles for both **macOS** and **Linux** using [chezmoi](https://www.chezmoi.io/), with Homebrew as the primary package manager on both platforms.

## Features

- ✅ **Unified package management** via Homebrew on both macOS and Linux
- ✅ **OS-specific configurations** using chezmoi templates
- ✅ **Automated setup** with install scripts
- ✅ **Git integration** with auto-commit and auto-push

## Installation

### Quick Start - Fresh Machine

**TL;DR** - One command to set up everything:

```bash
# macOS or Linux
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles
```

Replace `yourusername/dotfiles` with your repo!

**📖 For detailed instructions, troubleshooting, and step-by-step guide, see [BOOTSTRAP.md](BOOTSTRAP.md)**

### What This Does

The one-line command will:
- Install chezmoi
- Clone your dotfiles repository
- Prompt for machine type (home/work/server)
- **Linux**: Install Homebrew + essential packages
- **macOS**: Use existing Homebrew
- Install all packages from Brewfile
- Apply all dotfiles to your home directory
- Change shell to zsh
- Configure everything automatically

### Machine Types

- **home** - Personal laptop with Kubernetes tools, interactive 1Password
- **work** - Work laptop without Kubernetes, interactive 1Password
- **server** - AI assistant/automation, token-based 1Password (requires `OP_SERVICE_ACCOUNT_TOKEN`)

See [MACHINE_TYPES.md](MACHINE_TYPES.md) and [SERVER_SETUP.md](SERVER_SETUP.md) for details.

The setup will:
1. **Linux only**: Install Homebrew and essential build tools
2. Install all Homebrew packages (git, node, bat, eza, ripgrep, etc.)
3. **macOS only**: Install Homebrew cask applications
4. Configure zsh as default shell
5. Set up all dotfiles

## Script Execution Order

Scripts run in this order (chezmoi naming convention):

### Linux
1. `run_once_before_00-install-homebrew.sh` - Installs Homebrew on Linux
2. `run_once_before_01-install-linux-essentials.sh` - Installs Linux-specific packages (libfuse2, zsh, etc.)
3. `run_onchange_install-brew-packages.sh` - Installs packages from `Brewfile`
4. `run_once_after_chsh.sh` - Changes shell to zsh and builds bat cache

### macOS
1. `run_onchange_install-brew-packages.sh` - Installs packages and casks from `Brewfile`
2. `run_onchange_after_macos_defaults.sh` - Sets macOS-specific defaults
3. `run_onchange_after_configure.sh` - Additional macOS configuration
4. `run_once_after_chsh.sh` - Changes shell to zsh and builds bat cache

## Installed Packages

### Homebrew Packages (Both Platforms)
- **Shell tools**: bat, eza, fd, ripgrep, zoxide, tmux
- **Dev tools**: git, git-lfs, gh, lazygit, node
- **Utilities**: curl, wget

### macOS Casks
- Alacritty (terminal emulator)
- Nerd Fonts (Fira Code, Roboto Mono, Inconsolata)
- Visual Studio Code
- VLC
- 1Password CLI

### Linux-Specific (via apt)
- libfuse2 (AppImage support)
- zsh
- unzip

## Managing Dotfiles

### Add a new file
```bash
chezmoi add ~/.config/nvim/init.lua
```

### Edit a file
```bash
chezmoi edit ~/.zshrc
```

### Apply changes
```bash
chezmoi apply
```

### Update from remote
```bash
chezmoi update
```

## Customization

### Adding new Homebrew packages

Edit `Brewfile.tmpl` and add packages:

```ruby
# For CLI tools (both macOS and Linux)
brew "your-new-package"

# For macOS-only GUI apps
{{ if eq .chezmoi.os "darwin" -}}
cask "your-app"
{{ end -}}
```

Then apply changes:
```bash
chezmoi apply
brew bundle --global
```

### OS-specific configurations

Use chezmoi templates with conditionals:
```bash
{{ if eq .chezmoi.os "darwin" -}}
# macOS specific
{{ else if eq .chezmoi.os "linux" -}}
# Linux specific
{{ end -}}
```

## Troubleshooting

### Homebrew not found on Linux
Ensure your shell sources the Homebrew environment. The `.zshrc` includes:
```bash
if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
```

### Scripts not executing
Check script permissions:
```bash
chezmoi execute-template < .chezmoiscripts/run_onchange_install-brew-packages.sh.tmpl
```

### Re-run setup scripts
```bash
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

## Repository Structure

```
.
├── .chezmoi.toml.tmpl           # Chezmoi configuration
├── .chezmoiscripts/             # Setup scripts
│   ├── darwin/                  # macOS-specific scripts
│   ├── linux/                   # Linux-specific scripts
│   └── run_onchange_*.sh.tmpl   # Cross-platform scripts
├── dot_zshrc                    # Zsh configuration
├── dot_config/                  # Application configs
└── README.md                    # This file
```

## Changes from Previous Setup

The setup has been improved for cross-platform compatibility:

- ✅ Added Homebrew installation script for Linux
- ✅ Removed redundant apt package installations (now using Homebrew)
- ✅ Removed custom Node.js installation (now via Homebrew)
- ✅ Added proper PATH setup for Homebrew on Linux
- ✅ Added error handling and validation checks
- ✅ Unified package management across both platforms

Old scripts have been preserved as `.bak` files:
- `run_onchange_install-apt-packages.sh.tmpl.bak`
- `run_once_before_install-nodejs.sh.tmpl.bak`

## References

- [Chezmoi Documentation](https://www.chezmoi.io/)
- [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux)
