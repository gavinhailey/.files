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
  zsh-saml2aws
  fzf-tab
  zsh-osx-keychain
  zsh-autosuggestions
  zsh-syntax-highlighting
  aws
)

source $ZSH/oh-my-zsh.sh

# user configuration

## fzf

export FZF_COMPLETION_OPTS='--border --info=inline'

### disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
### set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
### set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
### preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
### switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

## default editor for local and remote sessions

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

## development environment version managers

### nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

## completions 

### saml2aws
eval "$(saml2aws --completion-script-zsh)"

## aliases

alias cat="bat"
alias vim="nvim"
alias vi="nvim"

### saml2aws
alias saml-login='saml2aws login --skip-prompt --session-duration=43200'
alias drake='saml2aws exec --exec-profile monolith -- bin/drake'
alias monolith-update='saml2aws exec --exec-profile monolith -- bin/drake update'
alias monolith-rspec='saml2aws exec --exec-profile monolith -- bin/drake spring rspec'
alias docker-login='saml2aws exec --exec-profile=monolith -- aws ecr get-login-password | docker login --password-stdin --username AWS 264606497040.dkr.ecr.us-east-1.amazonaws.com'
alias ecr='saml-monolith ./scripts/ecr.sh'

### tsa
alias tsa-stage='tlog-staging-admin'
alias tsa-prod='tlog-prod-admin'

## environment variables
export EDITOR='nvim'
export VISUAL='nvim'

### credentials
export NPM_BASE=$(keychain-environment-variable NPM_BASE)
export NPM_REPO_USERNAME=$(keychain-environment-variable NPM_REPO_USERNAME)
export NPM_REPO_PASSWORD=$(keychain-environment-variable NPM_REPO_PASSWORD)
export NPM_REPO_LOGIN="${NPM_REPO_USERNAME}:${NPM_REPO_PASSWORD}"
export GEM_REPO_LOGIN=$(keychain-environment-variable GEM_REPO_LOGIN)
export MVN_REPO_LOGIN=$(keychain-environment-variable MVN_REPO_LOGIN)
export MASTER_GENERATOR_LOGIN=$(keychain-environment-variable MASTER_GENERATOR_LOGIN)

### saml2aws qol
export AWS_FEDERATION_TOKEN_TTL=12h
export AWS_ASSUME_ROLE_TTL=1h
export AWS_DEFAULT_REGION=us-east-1
export AWS_SESSION_TTL=12h
export AWS_REGION=us-east-1
export SAML2AWS_LOGIN_SESSION_DURATION=43200
export SAML2AWS_SESSION_DURATION=3600

#### tlog
export KMS_ALIAS=alias/tlog-serverless-adapter-config-data

### path stuffs
export PATH="/Users/gavin.hailey/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"

## functions
function merge-this-branch {
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    gh pr merge $BRANCH -s -d --auto -b ''
}

function diff-to-html {
    nvim -d $1 $2 -c TOhtml -c "w $3" -c 'qa!'
}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

