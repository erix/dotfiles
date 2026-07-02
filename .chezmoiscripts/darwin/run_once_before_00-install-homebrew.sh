#!/bin/bash

set -eufo pipefail

echo -e "\033[0;32m>>>>> Checking Homebrew on macOS <<<<<\033[0m"

if command -v brew &>/dev/null; then
  echo "Homebrew is already installed at $(command -v brew)"
  exit 0
fi

if [[ ! -x /usr/bin/xcode-select ]]; then
  echo -e "\033[0;31mError: xcode-select is not available on this system\033[0m"
  exit 1
fi

if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Re-run chezmoi apply after the Xcode Command Line Tools installation completes."
  exit 1
fi

echo "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if command -v brew &>/dev/null; then
  echo -e "\033[0;32m>>>>> Homebrew installed successfully <<<<<\033[0m"
  brew --version
else
  echo -e "\033[0;31m>>>>> Homebrew installation failed <<<<<\033[0m"
  exit 1
fi
