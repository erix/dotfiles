# Machine Types - Work vs Home Setup

This dotfiles setup supports different package sets for work and home machines.

## 🏠 vs 💼 Package Differences

### Both Machines Get:
- Core dev tools: git, gh, lazygit, node
- Programming languages: Go, Python, Rust, Bun
- Modern CLI tools: bat, eza, fd, fzf, ripgrep, zoxide, neovim
- Container tools: Docker, Docker Compose, Colima
- Utilities: curl, wget, tmux

### Home Machine Only:
- Kubernetes tools: kubectl, k9s, kubeseal

### Work Machine:
- Skips Kubernetes tools

---

## 🆕 Fresh Machine Setup

When you bootstrap a fresh machine, you'll be prompted:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yourusername/dotfiles

# Prompts:
Email address: your@email.com
Is this a work machine (true/false): false  # ← Answer here
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

| Setting | Kubernetes Tools | Use Case |
|---------|------------------|----------|
| `isWorkMachine = false` | ✅ Installed | Home/Personal laptop |
| `isWorkMachine = true` | ❌ Skipped | Work laptop |

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
