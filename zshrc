if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

ENABLE_CORRECTION="true" 

plugins=(
  poetry
  git
  gh
  zsh-osx-keychain
  vscode
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# user configuration

## default editor for local and remote sessions

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

## development environment version managers

### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

### pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

### jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

### rbenv
eval "$(rbenv init - zsh)"

### rust
export PATH=$PATH:/Users/$USER/.cargo/bin

### go
export GOROOT="/opt/homebrew/opt/go"
export GOPATH="$HOME/.go"
export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"

## completions 

### saml2aws
eval "$(saml2aws --completion-script-zsh)"

## aliases

alias cat="bat"
alias vim="nvim"
alias vi="nvim"

### git
alias merge-this-branch="gh pr merge $(git rev-parse --abbrev-ref HEAD) -s -d --auto -b ''"

### saml2aws
alias saml-login='saml2aws login --skip-prompt --session-duration=43200'
alias saml-drake='saml2aws exec --exec-profile monolith -- bin/drake'
alias saml-update='saml2aws exec --exec-profile monolith --bin/drake update'
alias saml-rspec='saml2aws exec --exec-profile monolith -- bin/drake spring rspec'
alias saml-monolith='saml2aws exec --exec-profile monolith --'
alias saml-staging='saml2aws exec --exec-profile staging --'
alias saml-k8s='saml2aws exec --exec-profile k8s --'
alias docker-login='saml2aws exec --exec-profile=monolith -- aws ecr get-login-password | docker login --password-stdin --username AWS 264606497040.dkr.ecr.us-east-1.amazonaws.com'
alias ecr='saml-monolith ./scripts/ecr.sh'

### tsa
alias tsa-staging="saml2aws exec --exec-profile tlog-staging-admin --"
alias tsa-k8s="saml2aws exec --exec-profile tlog-prod-admin --"

## environment variables
### credentials
export NPM_BASE=$(keychain-environment-variable NPM_BASE)
export NPM_REPO_LOGIN=$(keychain-environment-variable NPM_REPO_LOGIN)
export GEM_REPO_LOGIN=$(keychain-environment-variable GEM_REPO_LOGIN)
export MVN_REPO_LOGIN=$(keychain-environment-variable MVN_REPO_LOGIN)
export MASTER_GENERATOR_LOGIN=$(keychain-environment-variable MASTER_GENERATOR_LOGIN)

### saml2aws qol
export AWS_FEDERATION_TOKEN_TTL=12h
export AWS_ASSUME_ROLE_TTL=1h
export AWS_DEFAULT_REGION=us-east-1
export AWS_SESSION_TTL=12h
export AWS_REGION=us-east-1
#### tlog
export KMS_ALIAS=alias/tlog-serverless-adapter-config-data

### path stuffs
export PATH="/Users/gavin.hailey/.local/bin:$PATH"
export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"

## functions
function diff-to-html() {
    vimdiff $1 $2 -c TOhtml -c "w $3" -c 'qa!'
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
