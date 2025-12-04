eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

set -p fish_complete_path $(brew --prefix)/share/fish/vendor_completions.d

fish_config theme choose "Solarized Light"
fish_vi_key_bindings

# aliases
alias docker-clean-dangling-images='docker rmi -f (docker images -f "dangling=true" -aq)'

export MISE_DATA_DIR="/mnt/EJS/MiseData"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=nvim
export GIT_EXTERNAL_DIFF=difft
export FZF_TMUX=1
export JAVA_HOME=/mnt/EJS/graalvm-jdk-25+37.1
export GRADLE_USER_HOME=/mnt/EJS/Projects/Gradle

# path
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.nix-profile/bin"
export PATH="$PATH:$JAVA_HOME/bin"

if status is-interactive
    atuin init fish | source
end

kubectl completion fish | source
mise activate fish | source
starship init fish | source
zoxide init fish | source
