eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

fish_vi_key_bindings

# aliases
alias docker-clean-dangling-images='docker rmi -f (docker images -f "dangling=true" -aq)'

export MISE_DATA_DIR="/mnt/EJS/MiseData"
export DOCKER_BUILDKIT=1 
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=nvim
export GIT_EXTERNAL_DIFF=difft
export FZF_TMUX=1

# path
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

if status is-interactive
  atuin init fish | source
end

kubectl completion fish | source
mise activate fish | source
starship init fish | source
