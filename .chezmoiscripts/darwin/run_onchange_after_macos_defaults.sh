#!/bin/bash

set -eufo pipefail

# better font rendering in Alacritty
defaults -currentHost write org.alacritty AppleFontSmoothing -int 0
