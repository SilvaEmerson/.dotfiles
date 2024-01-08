# To install following dependencies, in the legacy Nix versions, run:
# `nix-env -f deps.nix -i`
# or in the new Nix versions:
# `nix profile install -f deps.nix`
let
  pkgs = import <nixpkgs> { };
  borgmatic = import ./borgmatic;
in
with pkgs;
[
  Agda
  anydesk
  asdf-vm
  audacity
  aws-vault
  awscli2
  baobab
  bat
  borgbackup
  brave
  cbqn
  coq
  curl
  dbeaver
  delve
  difftastic
  dyalog
  elan
  emacs
  emote
  espanso
  firefox
  fish
  fzf
  gnome
  htop
  idris2
  j
  jq
  megasync
  nasm
  neovim
  nethogs
  nix
  nodePackages.typescript-language-server
  nushellFull
  obsidian
  picom
  podman
  podman-compose
  postman
  qbittorrent
  qemu
  redis
  ripgrep
  sqlc
  starship
  syncthing
  tealdeer
  tmux
  tree
  typescript
  uiua
  vault
  vifm
  wasmer
  wasmtime
  xclip
  xournalpp
  zotero
  borgmatic
]
