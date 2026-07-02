# Brewfile Guide

## Overview

This setup uses a **single `Brewfile.tmpl`** to manage all Homebrew packages across both macOS and Linux. The file is templated by chezmoi, so platform-specific packages (like macOS casks) are only included on the appropriate OS.

## File Location

- **Template**: `~/.local/share/chezmoi/Brewfile.tmpl`
- **Deployed**: `~/Brewfile` (after `chezmoi apply`)

## How It Works

1. **chezmoi applies** the template → generates `~/Brewfile` based on your OS
2. **Install script runs** `brew bundle --global` → reads from `~/Brewfile`
3. **Homebrew installs** everything listed in the Brewfile

## Adding Packages

### CLI Tools (Both macOS & Linux)

Just add them to the main section:

```ruby
# CLI Tools - Development
brew "git"
brew "gh"
brew "your-new-tool"  # ← Add here
```

### macOS-Only GUI Apps (Casks)

Add inside the conditional block:

```ruby
{{ if eq .chezmoi.os "darwin" -}}
# macOS-only casks
cask "wezterm"
cask "your-new-app"  # ← Add here
{{ end -}}
```

### Linux-Only Packages

Add with a conditional:

```ruby
{{ if eq .chezmoi.os "linux" -}}
brew "your-linux-only-package"
{{ end -}}
```

## Applying Changes

After editing `Brewfile.tmpl`:

```bash
# Apply the template to generate new ~/Brewfile
chezmoi apply

# Install new packages
brew bundle --global

# Or do both at once
chezmoi apply && brew bundle --global
```

## Brewfile Commands

```bash
# Install everything in ~/Brewfile
brew bundle --global

# Check what would be installed/upgraded
brew bundle --global check

# Cleanup packages not in Brewfile
brew bundle --global cleanup

# See what's in your Brewfile
cat ~/Brewfile
```

## Advantages Over Shell Scripts

✅ **Standard format** - Uses Homebrew's native Brewfile format
✅ **Cleaner syntax** - No bash loops or heredocs
✅ **Better tooling** - `brew bundle` commands for management
✅ **Idempotent** - Only installs what's missing
✅ **Version control** - Easy to track changes in git
✅ **Comments** - Can document why packages are installed

## Example Brewfile Structure

```ruby
# Taps
tap "homebrew/bundle"
tap "homebrew/cask-fonts"

# Essential CLI tools
brew "git"
brew "node"

# Modern Unix tools
brew "bat"        # Better cat
brew "eza"        # Better ls
brew "ripgrep"    # Better grep

{{ if eq .chezmoi.os "darwin" -}}
# macOS-only applications
cask "visual-studio-code"
cask "wezterm"
{{ end -}}
```

## Troubleshooting

### "Brewfile not found"
```bash
# Regenerate Brewfile from template
chezmoi apply
```

### See what packages will be installed
```bash
# View your generated Brewfile
cat ~/Brewfile

# Check if it's valid
brew bundle --global check --verbose
```

### Package fails to install
```bash
# Update Homebrew first
brew update

# Try installing individually
brew install package-name

# Check for OS restrictions
brew info package-name
```

## Migration Note

This setup **replaces** the old approach of listing packages in shell script arrays. The old scripts have been backed up as `.bak` files for reference.
