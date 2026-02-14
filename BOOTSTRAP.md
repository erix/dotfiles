# Bootstrap Guide - Fresh Machine Setup

This guide shows how to set up your dotfiles on a brand new, clean machine.

## Prerequisites

**You need:**
- Internet connection
- Your dotfiles git repository URL (e.g., `https://github.com/yourusername/dotfiles.git`)

**That's it!** Everything else will be installed automatically.

## 🔄 How Bootstrap Works (No Chicken-Egg Problem!)

The one-line command installs things in this order:

1. **`get.chezmoi.io` script** → Downloads chezmoi as standalone binary (no Homebrew!)
2. **chezmoi** → Clones your dotfiles and runs setup scripts
3. **Setup scripts** → Install Homebrew (Linux) or use existing (macOS)
4. **Homebrew** → Installs all packages from Brewfile

**Key insight**: Chezmoi is installed as a standalone binary FIRST, so it doesn't need Homebrew to exist yet!

---

## 🍎 macOS Setup

### Recommended: One-Command Bootstrap

**No prerequisites needed** - works on completely fresh Mac:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles
```

This installs chezmoi as a standalone binary (no Homebrew required), then chezmoi uses your existing Homebrew or installs packages.

### Alternative: If You Prefer Homebrew First

If you want to install Homebrew yourself first:

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install chezmoi via Homebrew
brew install chezmoi

# 3. Run chezmoi
chezmoi init --apply https://github.com/yourusername/dotfiles.git
```

**Note**: This is longer but some prefer installing Homebrew manually first.

---

## 🐧 Linux Setup (Debian/Ubuntu)

### One-Command Bootstrap (Recommended)

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles
```

**That's it!** This will:
1. Download and install **chezmoi as standalone binary** (no Homebrew needed!)
2. Clone your dotfiles repository
3. Run all setup scripts automatically:
   - **Install Homebrew for Linux** (chezmoi installs this for you!)
   - Install essential system packages (zsh, libfuse2, etc.)
   - Install all Homebrew packages from your Brewfile
   - Change shell to zsh
   - Set up all dotfiles

**⚠️ Important**: Do NOT try `brew install chezmoi` on fresh Linux - Homebrew doesn't exist yet! The `get.chezmoi.io` script installs chezmoi first, THEN chezmoi installs Homebrew.

### Manual Steps (If Preferred)

```bash
# 1. Install chezmoi as standalone binary
curl -sfL https://git.io/chezmoi | sh
sudo mv ./bin/chezmoi /usr/local/bin/

# 2. Initialize and apply (this will install Homebrew)
chezmoi init --apply https://github.com/yourusername/dotfiles.git
```

---

## 🔄 What Happens During Setup?

### Interactive Prompts

During `chezmoi init`, you'll be asked:
```
Email address: your@email.com
```

This is stored in `.chezmoi.toml` and used for git configuration.

### Automatic Installation

Then chezmoi will automatically:

#### On Linux:
```
✓ Clone dotfiles repository
✓ Install Homebrew (with dependencies)
✓ Install zsh, libfuse2, unzip via apt
✓ Install all Brewfile packages via Homebrew
  → git, node, bat, eza, fd, ripgrep, etc.
✓ Apply all dotfiles to ~
✓ Change shell to zsh
✓ Build bat cache
```

#### On macOS:
```
✓ Clone dotfiles repository
✓ Install all Brewfile packages via Homebrew
  → CLI tools: git, node, bat, eza, etc.
  → GUI apps: Alacritty, VSCode, VLC, etc.
  → Fonts: Fira Code Nerd Font, etc.
✓ Apply all dotfiles to ~
✓ Configure macOS defaults
✓ Change shell to zsh
✓ Build bat cache
```

---

## ⏱️ Expected Time

- **macOS**: 10-15 minutes (depends on cask downloads)
- **Linux**: 15-20 minutes (Homebrew installation takes longer)

---

## 🔧 After Installation

### Verify Installation

```bash
# Check chezmoi is working
chezmoi doctor

# Check Homebrew is installed
brew --version

# Check packages are installed
which git node bat eza fd rg

# Check dotfiles are applied
ls -la ~/ | grep zshrc
```

### Start Using Your Setup

```bash
# Reload shell to use zsh
exec zsh

# Or log out and back in
```

---

## 🚨 Troubleshooting

### "Permission denied" during install

On Linux, you may need sudo for changing shell:
```bash
# Enter your password when prompted
sudo chsh -s $(which zsh) $USER
```

### Homebrew not in PATH (Linux)

If `brew` command not found after install:
```bash
# Add to current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Then re-run
chezmoi apply
```

This is temporary - your `.zshrc` will handle it permanently.

### Scripts not running

If setup seems incomplete:
```bash
# Check what scripts ran
chezmoi execute-template --init --promptString "email=you@email.com"

# Force re-run scripts
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Chezmoi asking for email again

Your `.chezmoi.toml` remembers your email. To update it:
```bash
chezmoi edit-config
```

---

## 📝 Post-Setup Checklist

After bootstrap completes:

- [ ] Shell changed to zsh (check: `echo $SHELL`)
- [ ] Homebrew installed (check: `brew --version`)
- [ ] Git configured (check: `git config --global user.email`)
- [ ] Dotfiles applied (check: `ls -la ~/`)
- [ ] CLI tools work (check: `bat --version`, `eza --version`)
- [ ] On macOS: GUI apps installed (check Applications folder)

---

## 🔄 Keeping Up to Date

After initial setup, keep your dotfiles updated:

```bash
# Pull latest changes and apply
chezmoi update

# Or manually
chezmoi git pull && chezmoi apply
```

---

## 🔐 Private Repository Setup

If your dotfiles repo is private:

### Using SSH (Recommended)

```bash
# 1. Generate SSH key
ssh-keygen -t ed25519 -C "your@email.com"

# 2. Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy output and add to GitHub Settings → SSH Keys

# 3. Initialize with SSH URL
chezmoi init --apply git@github.com:yourusername/dotfiles.git
```

### Using HTTPS with Token

```bash
# You'll be prompted for username and password/token
chezmoi init --apply https://github.com/yourusername/dotfiles.git
```

---

## 🎯 Quick Reference Card

**Save this for bootstrapping new machines:**

### macOS
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles
```

### Linux (Debian/Ubuntu)
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles
```

Replace `yourusername/dotfiles` with your repository path!

---

## 📦 What Gets Installed

Everything from your `Brewfile`:
- **Dev tools**: git, git-lfs, gh, lazygit, node
- **Modern CLI**: bat, eza, fd, ripgrep, zoxide, tmux
- **Utilities**: curl, wget
- **macOS only**: Alacritty, VSCode, VLC, Fonts

All your dotfiles:
- `.zshrc` with aliases and configurations
- `.config/` directory contents
- Git configuration
- Any other tracked files

---

## 🆘 Need Help?

1. Check chezmoi status: `chezmoi doctor`
2. View what would change: `chezmoi diff`
3. See what scripts exist: `ls -R $(chezmoi source-path)/.chezmoiscripts/`
4. Check chezmoi docs: https://www.chezmoi.io/

---

**Pro Tip**: Test your bootstrap process in a virtual machine or Docker container before relying on it for a real machine setup!
