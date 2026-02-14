#!/bin/bash

set -eufo pipefail

# Rebuild the bat theme cache if bat is available
if command -v bat &>/dev/null; then
  echo "Rebuilding bat cache..."
  bat cache --build
else
  echo "Warning: bat is not installed, skipping cache build"
fi

# Check if the current shell is already zsh
if [[ "$SHELL" != */zsh ]]; then
  # Check if zsh is installed
  if command -v zsh &>/dev/null; then
    echo "Changing shell to zsh..."
    chsh -s $(which zsh)
    echo "Shell changed to zsh. Please log out and log back in for the changes to take effect."
  else
    echo "zsh is not installed. Please install zsh first."
    exit 1
  fi
else
  echo "Your shell is already zsh."
fi
