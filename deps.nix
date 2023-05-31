# To install following dependencies run:
# `nix-env -f deps.nix -i`
let
  pkgs = import <nixpkgs> { };
in
with pkgs;
[
  curl
  htop
  tree
  xclip
  firefox
  brave
  nushell
  fish
  wasmer
  wasmtime
  postman
  dbeaver
  vault
  aws-vault
  awscli2
  neovim
  emacs
  podman
  podman-compose
  asdf-vm
  redis
  sqlc
  delve
]
