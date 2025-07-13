fish_vi_key_bindings
fzf_key_bindings

source $HOME/.nix-profile/share/asdf-vm/asdf.fish

# kubectl completion fish | source

# aliases
alias docker-clean-dangling-images='docker rmi -f (docker images -f "dangling=true" -aq)'

# variables
export DOCKER_BUILDKIT=1 
export COMPOSE_DOCKER_CLI_BUILD=1
export EDITOR=vim
# export DISPLAY=(ip route list default | awk '{print $3}'):0
# export LIBGL_ALWAYS_INDIRECT=1
export GPG_TTY=(tty)

# path
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

export GIT_EXTERNAL_DIFF=difft

# Preview file content using bat (https://github.com/sharkdp/bat)
export FZF_CTRL_T_OPTS="
  --preview 'bat -n --color=always {} 2> /dev/null || tree {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-p:toggle-preview'
  --color header:italic"

# Print tree structure in the preview window
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

export FZF_TMUX=1

starship init fish | source
