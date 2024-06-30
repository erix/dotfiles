#!/bin/bash

set -eufo pipefail

# better font rendering in Alacritty
defaults -currentHost write -g AppleFontSmoothing -int 0
