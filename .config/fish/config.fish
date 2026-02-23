eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)

set -p fish_complete_path $(brew --prefix)/share/fish/vendor_completions.d

fish_config theme choose flexoki-light
fish_vi_key_bindings

# aliases
alias docker-clean-dangling-images='docker rmi -f (docker images -f "dangling=true" -aq)'
alias oc='opencode'

export MISE_DATA_DIR="/mnt/EJS/MiseData"
export ELAN_HOME="/mnt/EJS/Lean4Data"
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=nvim
export GIT_EXTERNAL_DIFF=difft
export FZF_TMUX=1
export JAVA_HOME=/mnt/EJS/graalvm-jdk-25+37.1
export GRADLE_USER_HOME=/mnt/EJS/Projects/Gradle
export TEXMFHOME="/mnt/EJS/texmf"
export GH_TOKEN=(keyring get gh token)
export MISE_RUSTUP_HOME=/mnt/EJS/RustToolchain/rustup
export MISE_CARGO_HOME=/mnt/EJS/RustToolchain/cargo

# path
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$MISE_CARGO_HOME/bin"
export PATH="$PATH:$HOME/.nix-profile/bin"
export PATH="$PATH:$JAVA_HOME/bin"
export PATH="$PATH:$ELAN_HOME/bin"

if status is-interactive
    atuin init fish | source
end

kubectl completion fish | source
mise activate fish | source
starship init fish | source
zoxide init fish | source
