import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0c32f40fe3e2a9adfc427fd5abc061a31043ea44.tar.gz";
    sha256 = "11gv5qs8r9vljy5ja4figvfpflffip0ylnnqdik04054ni6crh2n";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/1f9b16313689e8451570f64a80fdcb4183663e9f.tar.gz";
    sha256 = "0a9vg5vdd69kr7jfhmbbja6wj9i2mc5gavn65mix2wmsxzwzlfl4";
  }) {nixpkgs=nixpkgs;};

}
