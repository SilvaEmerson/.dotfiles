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
  wasmer
  wasmtime
]
