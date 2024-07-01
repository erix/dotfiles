#!/bin/bash

set -eufo pipefail

# rebuild the bat theme cache
bat cache --build

#chsh -s $(which zsh)
