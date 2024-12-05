# set global editor
export EDITOR=nvim

# ensure kitty colors work with vim and tmux
export TERM='xterm-kitty'

# openssl
export PATH="/opt/homebrew/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

export DEVELOPER_HOME="$HOME/Developer"
export SANDBOX_HOME="$DEVELOPER_HOME/Sandbox"

# config files
export CASA_CONFIG="$HOME/Developer/Casa"
export CONFIG_HOME="$HOME/.config"

# engi
export ENGI_MONOREPO_DIR="$HOME/Developer/engi/engi"

# nvm  
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # load nvm completion

# rg
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border none --info=inline --preview 'bat --color=always {}' --preview-window '~3'" # style fzf ui

# source cargo
. "$HOME/.cargo/env"

# openai
export OPENAI_API_KEY="REDACTED_OPENAI_API_KEY"

# conda
export PATH="/usr/local/anaconda3/bin:$PATH"

# ruby
export PATH="$HOME/.rbenv/bin:$PATH"

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export PATH="$PATH:/Users/g/.foundry/bin"
