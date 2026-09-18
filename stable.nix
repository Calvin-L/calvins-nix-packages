import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0c32f40fe3e2a9adfc427fd5abc061a31043ea44.tar.gz";
    sha256 = "11gv5qs8r9vljy5ja4figvfpflffip0ylnnqdik04054ni6crh2n";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/8f7cee1897bfc48ef323620ce341750a0b873c69.tar.gz";
    sha256 = "0q0n9gagjkd6i9v3r4wm9yyig5xljylxgzac4rjskrmy7jv3wfc2";
  }) {nixpkgs=nixpkgs;};

}
