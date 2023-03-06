#!/bin/zsh

function install_all_packages {
  brew update  

  install_oh_my_zsh
  install_pyenv
  install_rbenv
  install_nvm
  install_jenv
  brew install go
  install_rust

  install_my_zshrc
  install_gitconfig
  install_ssh_config

  source ~/.zshrc || true

  install_python_poetry
  install_neovim

  brew install bat awscli saml2aws gh fzf ripgrep tldr htop tree jq tmux openssh gnu-getopt gnupg
}

function install_pyenv {
  DEFAULT_PYTHON_VERSION="3.9.16"
  echo "Installing pyenv and python ${DEFAULT_PYTHON_VERSION}"
  brew install pyenv
  echo "alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'" >> ~/.zshrc
  source ~/.zshrc || true
  pyenv install ${DEFAULT_PYTHON_VERSION}
  pyenv global ${DEFAULT_PYTHON_VERSION}
  pyenv rehash
}

function install_python_poetry {
  echo "Installing python poetry"
  curl -sSL https://install.python-poetry.org | python3 -
}

function install_rbenv {
  echo "Installing rbenv"
  brew install rbenv ruby-build
}

function install_nvm {
  echo "Installing nvm"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  source ~/.zshrc || true
  nvm install --lts && nvm use --lts
}

function install_jenv {
  echo "Installing jenv"
  brew install jenv
  brew install openjdk@11
  jenv add "$(/usr/libexec/java_home)"
}

function install_rust {
  echo "Installing rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path
}

function install_docker_colima {
  echo "Installing docker + colima"
  brew install colima docker
}

function install_neovim {
  echo "Installing neovim"
  brew install neovim
  LV_BRANCH='release-1.2/neovim-0.8' bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/fc6873809934917b470bff1b072171879899a36b/utils/installer/install.sh)
  git clone https://github.com/nvim-lua/kickstart.nvim.git $HOME/.config/nvim
}

function install_oh_my_zsh {
  echo "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  # zsh plugins
  echo "Installing oh-my-zsh plugins"
  git clone https://github.com/onyxraven/zsh-osx-keychain.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-osx-keychain
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

  # restart shell
  echo "Configure p10k..."
  source ~/.zshrc
  p10k configure
}

function install_my_zshrc {
  echo "Installing my zshrc"
  rm -f ~/.zshrc
  ln -s $DOTFILES_PATH/zshrc ~/.zshrc
}

function install_ssh_config {
  echo "Installing ssh config"
  mkdir -p ~/.ssh
  rm -f ~/.ssh/config
  ln -s $DOTFILES_PATH/ssh/config ~/.ssh/config
}

function install_gitconfig {
  echo "Installing gitconfig"
  rm -f ~/.gitconfig
  ln -s $DOTFILES_PATH/gitconfig ~/.gitconfig
}
