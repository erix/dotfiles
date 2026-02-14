# Server / AI Assistant Setup Guide

Guide for setting up dotfiles on servers, AI assistants, or automated environments using 1Password Service Accounts.

## 🖥️ What is a Server Machine?

Server machine type is for:
- **AI assistants** (like your OpenClaw setup)
- **Automation servers** (CI/CD runners, cron jobs)
- **Headless servers** (no GUI, SSH-only access)
- **Any environment** where you can't interactively log in to 1Password

## 🔑 1Password Service Accounts

Server machines use **1Password Service Accounts** instead of regular accounts:

| Feature | Regular Account | Service Account |
|---------|----------------|-----------------|
| Login | Interactive (browser/app) | Token-based |
| Authentication | Email + password + 2FA | `OP_SERVICE_ACCOUNT_TOKEN` |
| Best for | Personal/work laptops | Servers, automation |
| Cost | Free/paid personal | Paid (team/business) |

## 📋 Prerequisites

1. **1Password Business/Teams account** (Service Accounts require paid plan)
2. **Service Account created** in 1Password
3. **Token with vault access** to the vaults containing your secrets

## 🚀 Setup Steps

### 1. Create 1Password Service Account

In 1Password web interface:

1. Go to **Settings** → **Service Accounts**
2. Click **Create Service Account**
3. Name it (e.g., "OpenClaw Server", "AI Assistant")
4. Grant access to vaults:
   - `ClawdBot` vault (for Claude Code token)
   - `Private` vault (for GitHub token)
   - Any other vaults your dotfiles reference
5. **Copy the token** (starts with `ops_...`)
   - ⚠️ Save it securely! You can't view it again

### 2. Set Environment Variable

On your Linux server:

```bash
# Add to ~/.bashrc or ~/.zshrc (or set in your deployment)
export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here_very_long_string"

# Make it permanent
echo 'export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token_here"' >> ~/.bashrc
source ~/.bashrc

# Verify it's set
echo $OP_SERVICE_ACCOUNT_TOKEN
```

**Security Note**: For production servers, use a secrets manager (AWS Secrets Manager, Kubernetes secrets, etc.) instead of storing in shell config.

### 3. Bootstrap Dotfiles

```bash
# With token set, run chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply erix/dotfiles

# Prompts:
Email address: your@email.com
Machine type (home/work/server): server  # ← Select server
```

### 4. Verify

Check that secrets were retrieved:

```bash
# Check Claude Code token is set
echo $CLAUDE_CODE_OAUTH_TOKEN | head -c 20  # Should show first 20 chars

# Check GitHub CLI is configured
gh auth status
```

## 🔧 Configuration Details

When you select `machineType = "server"`, chezmoi config includes:

```toml
[data]
    machineType = "server"
    isServerMachine = true

[onepassword]
    mode = "service-account"
```

This tells chezmoi to:
- Use `OP_SERVICE_ACCOUNT_TOKEN` for authentication
- Not prompt for interactive 1Password login
- Skip Kubernetes tools installation

## 📦 What Gets Installed

Server machines get:
- ✅ All core dev tools and languages
- ✅ Docker and Colima
- ✅ Modern CLI tools
- ❌ No Kubernetes tools (kubectl, k9s)
- ❌ No macOS GUI apps

## 🐛 Troubleshooting

### "1password CLI not found"

Install 1Password CLI manually first:

```bash
# Linux
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list
sudo apt update && sudo apt install 1password-cli
```

### "unauthorized" or "invalid token"

Check your token is valid:

```bash
# Test the token
op vault list

# Should show your vaults. If error, token is invalid/expired
```

### "no such secret"

Verify your service account has access to the vault:

```bash
# List accessible vaults
op vault list

# Try to read the specific secret
op read "op://ClawdBot/Claude Max Token/credential"
```

If not found, add vault access in 1Password web interface.

### Secrets not being read during chezmoi apply

Make sure the token is exported in your current shell:

```bash
# Check it's set
env | grep OP_SERVICE

# If not set, export it
export OP_SERVICE_ACCOUNT_TOKEN="ops_your_token"

# Then re-run
chezmoi apply
```

## 🔄 Updating Secrets

When you rotate tokens or secrets in 1Password:

```bash
# Just re-apply dotfiles
chezmoi apply

# Templates will fetch fresh values from 1Password
```

## 🔐 Security Best Practices

### For Development/Testing
```bash
# Store token in shell config
export OP_SERVICE_ACCOUNT_TOKEN="ops_..."
```

### For Production Servers
```bash
# Use systemd environment files
# /etc/systemd/system/myservice.service.d/override.conf
[Service]
EnvironmentFile=/etc/secrets/1password

# /etc/secrets/1password (mode 600, root-only)
OP_SERVICE_ACCOUNT_TOKEN=ops_...
```

### For Docker/Kubernetes
```yaml
# Pass as environment variable
env:
  - name: OP_SERVICE_ACCOUNT_TOKEN
    valueFrom:
      secretKeyRef:
        name: onepassword-token
        key: token
```

## 📚 References

- [1Password Service Accounts Docs](https://developer.1password.com/docs/service-accounts/)
- [1Password CLI Reference](https://developer.1password.com/docs/cli/)
- [Chezmoi 1Password Integration](https://www.chezmoi.io/user-guide/password-managers/1password/)

## 💡 Example: OpenClaw Setup

For your AI assistant setup:

```bash
# On your Linux server
export OP_SERVICE_ACCOUNT_TOKEN="ops_OpenClaw_token_here"
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply erix/dotfiles

# Select: server
# This will:
# - Install all dev tools
# - Configure Claude Code with token from 1Password
# - Configure GitHub CLI with token from 1Password
# - Skip Kubernetes tools
# - Use token-based 1Password (no interactive login)
```
