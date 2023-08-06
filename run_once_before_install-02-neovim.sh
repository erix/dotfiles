#!/bin/bash

echo -e "Setting up Neovim with NvChad"
# Neovim and NvChad dependencies install
brew install neovim
brew install ripgrep

# Make sure we have clear install
if [ -d $HOME/.config/nvim ]; then
  rm -rf $HOME/.config/nvim
fi
if [ -d $HOME/.local/share/nvim ]; then
  rm -rf $HOME/.local/share/nvim
fi

# NvChad
git clone https://github.com/NvChad/NvChad $HOME/.config/nvim --depth 1 && nvim
