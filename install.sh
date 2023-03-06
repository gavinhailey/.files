#!/bin/zsh

DOTFILES_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $DOTFILES_PATH/packages.sh

install_all_packages
