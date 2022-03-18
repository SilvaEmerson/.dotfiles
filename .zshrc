    # If you come from bash you might have to change your $PATH.
    #export PATH=$HOME/bin:/usr/local/bin:$PATH
cat ~/cat_sleeping.txt

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="spaceship"

SPACESHIP_PYENV_SHOW="always"
SPACESHIP_PYENV_COLOR="blue"
SPACESHIP_BATTERY_SHOW="always"
SPACESHIP_USER_SHOW="always"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
#ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

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
plugins=(
	pip
	yarn
	npm
	archlinux
	pyenv
	node
	git
    fast-syntax-highlighting
	zsh-autosuggestions
    zsh-completions
)

autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

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
export PATH="/home/emerson/.pyenv/bin:$PATH"
export PATH="/home/emerson/.local/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PATH="$(yarn global bin):$PATH"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias gwtwo="lutris lutris:rungameid/6"

# clean ALL Docker images with <none> tags
alias docker-clean-dangling-images='docker rmi -f (docker images -f "dangling=true" -aq)'

export PATH="/home/emerson/.gem/ruby/2.6.0/bin:$PATH"
export PATH=~/.npm-global/bin:$PATH
export PATH="/home/emerson/.deno/bin:$PATH"
export PATH="/usr/lib/jvm/java-12-openjdk/bin/:$PATH"
export PATH="$PATH:$HOME/.cargo/bin"
fpath=($fpath "/home/emerson/.zfunctions")


# Set Proxy
function setproxy() {
    export {http,https}_proxy="proxy.ufal.br:3128"
}

# Unset Proxy
function unsetproxy() {
    unset {http,https,ftp}_proxy
}

function checkupdates(){
    upgradablePackages=`sudo pacman -Qu | wc -l`

    if [ "$upgradablePackages" -gt 0 ]; then
        echo "You need to update some packages :)"
    else
        echo "System up to date"
    fi
}

eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
bindkey -v
cat ~/cat_wake.txt
echo ".-$ whoami\n|\n'-> "$(whoami)
# tabtab source for electron-forge package
# uninstall by removing these lines or running `tabtab uninstall electron-forge`
[[ -f /home/emerson/Documents/Projects/ElectronDemo/node_modules/tabtab/.completions/electron-forge.zsh ]] && . /home/emerson/Documents/Projects/ElectronDemo/node_modules/tabtab/.completions/electron-forge.zsh
