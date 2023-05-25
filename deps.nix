# To install following dependencies, in the legacy Nix versions, run:
# `nix-env -f deps.nix -i`
# or in the new Nix versions:
# `nix profile install -f deps.nix`
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
]
