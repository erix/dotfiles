# Machine Types - Home / Work / Server Setup

This dotfiles setup supports three machine types with different configurations.

## 🏠 Home / 💼 Work / 🖥️ Server

### Machine Types

| Type | Kubernetes | 1Password Mode | Use Case |
|------|------------|----------------|----------|
| **home** | ✅ kubectl, k9s, kubeseal | Interactive account | Personal laptop |
| **work** | ❌ Skipped | Interactive account | Work laptop |
| **server** | ❌ Skipped | Service account token | AI assistant, automation |

### All Machines Get:
- Core dev tools: git, gh, lazygit, node
- Programming languages: Go, Python, Rust, Bun
- Modern CLI tools: bat, eza, fd, fzf, ripgrep, zoxide, neovim
- Container tools: Docker, Docker Compose, Colima
- Utilities: curl, wget, tmux

### Home Machine Only:
- Kubernetes tools: kubectl, k9s, kubeseal

### Server Machine Special Config:
- 1Password uses service account (token-based, no interactive login)
- Requires `OP_SERVICE_ACCOUNT_TOKEN` environment variable

---

## 🆕 Fresh Machine Setup

When you bootstrap a fresh machine, you'll be prompted:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles

# Prompts:
Email address: your@email.com
Machine type (home/work/server): home  # ← Choose one
```

### For Server/AI Assistant Setup

Before running chezmoi on a server, set your 1Password service account token:

```bash
# Get your service account token from 1Password
# https://developer.1password.com/docs/service-accounts/get-started/

export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"

# Then run chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles

# When prompted, select:
Machine type: server
```

---

## 🔧 Existing Machine - Change Setting

### Option 1: Edit Config Directly

```bash
chezmoi edit-config
```

Add or modify:
```toml
[data]
    email = "your@email.com"
    osid = "darwin"  # or "linux-ubuntu", etc.
    isWorkMachine = false  # ← Add this line (true or false)
```

### Option 2: Re-run Init (Prompt Again)

```bash
# Remove stored answer
chezmoi state delete-bucket --bucket=configState

# This will prompt again on next apply
chezmoi init
```

---

## 📦 Preview What Will Be Installed

### See Your Current Settings

```bash
chezmoi data | grep -A 5 '"data"'
```

### Generate and Preview Brewfile

```bash
# See what Brewfile would be generated
chezmoi execute-template < ~/.local/share/chezmoi/Brewfile.tmpl

# Or apply and check
chezmoi apply
cat ~/Brewfile
```

---

## 🎯 Quick Reference

| Setting | Kubernetes | 1Password Mode | Use Case |
|---------|------------|----------------|----------|
| `machineType = "home"` | ✅ Installed | account | Personal laptop |
| `machineType = "work"` | ❌ Skipped | account | Work laptop |
| `machineType = "server"` | ❌ Skipped | service-account | AI assistant, server |

---

## 🔄 Switching Machine Type

If you initially set up as "work" but want to change to "home":

```bash
# 1. Update config
chezmoi edit-config
# Change: isWorkMachine = false

# 2. Regenerate Brewfile
chezmoi apply

# 3. Install new packages
brew bundle --global

# 4. Verify
brew list | grep kubectl  # Should show kubectl if home machine
```

---

## ➕ Adding More Machine-Specific Packages

Edit `Brewfile.tmpl`:

```ruby
{{ if ne .isWorkMachine true -}}
# Home/Personal Machine Only
brew "kubernetes-cli"
brew "k9s"
brew "your-personal-tool"  # ← Add here
{{ end -}}

{{ if eq .isWorkMachine true -}}
# Work Machine Only
brew "your-work-specific-tool"  # ← Add work-only tools
{{ end -}}
```

---

## 💡 Pro Tips

### 1. Test Both Configurations

```bash
# Preview as work machine
chezmoi execute-template --init \
  --promptString "email=test@test.com" \
  --promptBool isWorkMachine=true \
  < Brewfile.tmpl

# Preview as home machine
chezmoi execute-template --init \
  --promptString "email=test@test.com" \
  --promptBool isWorkMachine=false \
  < Brewfile.tmpl
```

### 2. Document Your Choice

The setting is stored in `~/.config/chezmoi/chezmoi.toml`, so you can always check:

```bash
cat ~/.config/chezmoi/chezmoi.toml
```

### 3. Multiple Work Environments

If you have different work environments, you could extend this:

```toml
[data]
    machineType = "home"  # or "work-clientA", "work-clientB"
```

Then in Brewfile:
```ruby
{{ if eq .machineType "work-clientA" -}}
brew "client-a-specific-tool"
{{ end -}}
```

---

## 🆘 Troubleshooting

### "isWorkMachine not defined"

If you get template errors, make sure `.chezmoi.toml` has:

```toml
[data]
    isWorkMachine = false  # or true
```

### Want to see what's different between machines?

```bash
# Generate work machine Brewfile
echo 'isWorkMachine: true' | chezmoi execute-template < Brewfile.tmpl > /tmp/brewfile-work

# Generate home machine Brewfile
echo 'isWorkMachine: false' | chezmoi execute-template < Brewfile.tmpl > /tmp/brewfile-home

# Compare
diff /tmp/brewfile-work /tmp/brewfile-home
```
