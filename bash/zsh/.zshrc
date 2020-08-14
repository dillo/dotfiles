ZSH_DISABLE_COMPFIX=true
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:/Users/draju:~/bin:/usr/local:/usr/bin:/usr/local/sbin:~/.cargo/bin:/Applications
export NVM_DIR="$HOME/Development/NonRentPath/tools/.nvm"
export ZSH=$HOME/.config/yarn/global
export ZSH=$HOME/.oh-my-zsh
export EDITOR=vim
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# Path to your oh-my-zsh installation.
export KERL_CONFIGURE_OPTIONS="--disable-debug --disable-silent-rules --without-javac --enable-shared-zlib --enable-dynamic-ssl-lib --enable-hipe --enable-sctp --enable-smp-support --enable-threads --enable-kernel-poll --enable-wx --enable-darwin-64bit --with-ssl=/usr/bin/openssl"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
. $HOME/.asdf/asdf.sh
fpath=("$HOME/.zsh/pure" "$HOME/bin" "/usr/local" "/usr/bin" "$HOME/.cargo/bin" "$HOME/.asdf/completions" $fpath)
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

source /Users/draju/.oh-my-zsh/oh-my-zsh.sh

plugins=(git)
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# Aliases
alias pry="pry --simple-prompt"
alias postgres_start="pg_ctl -D /usr/local/var/postgres -l logfile start"
alias postgres_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"
alias bake="bundle exec rake"
alias pip="pip3"
alias bec="bundle exec rspec spec/"
alias gst="git status"
alias gco="git checkout"
alias gci="git commit"
alias gas="git stash"
alias gpr="git pull --rebase"
alias gbr="git branch"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gpo="git push origin"
alias gbr_d="git branch --merged | grep -v '\*' | xargs -n 1 git branch -d"
alias gbr_del="git branch -r --merged dev | grep -v -E 'master|dev|qa|release' | sed  -e 's/origin\///' | xargs git push origin --delete"
alias cv="rm -rf spec/vcr_cassettes"
alias pj="python -m json.tool"
alias bbox="ssh draju@bot001.tools.useast2.rentpath.com -t sudo su - deploy"
alias cut="curl -o -s -w %{time_total}\\n"
alias redis='redis-cli -n 1 -h localhost'
alias vcam="sudo killall VDCAssistant"
alias consul_ci="envconsul -consul-addr=consul001.useast2.rentpath.com:8500 -prefix env/ci -upcase -sanitize -pristine env"
alias sfo="ls -p | grep -v /"
alias apache_stop="sudo /usr/sbin/apachectl stop"
alias webpack_errors="webpack --display-error-details"
alias check='mix test && mix credo && mix dialyzer'
alias start_gateway="ELASTICSEARCH_DEBUG=true envconsul -consul-addr=https://consul-useast2.tools.rentpath.com -once -prefix env/ci/elasticsearch -prefix env/ci/mobile_gateway -upcase -sanitize -pristine env | sort > ~/.mobile_gateway_env.txt && while read line; do export $line; done < ~/.mobile_gateway_env.txt && mix phx.server"
alias rb="cd ~/Development/RentPath/source/ruby/"
alias flog="find /Users/draju/Development/RentPath/source/ruby/rnr_ui/app -name \*.rb | xargs flog"
autoload -Uz promptinit && promptinit
autoload -Uz compinit && compinit

prompt pure

source /Users/draju/Library/Preferences/org.dystroy.broot/launcher/bash/br
# export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
# export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"export PATH="/usr/local/sbin:$PATH"
