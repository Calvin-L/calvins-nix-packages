import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/4989a246d7a390a859852baddb1013f825435cee.tar.gz";
    sha256 = "0mdyxfmhgqnyvfv104f6gjvqva7inizv1d6jjshbc532ykj51h4h";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/78710548665da11cf69d08fa4586dead4dda0695.tar.gz";
    sha256 = "0i7nv07a34kh801kff15av8c4rpdydw02v23la7wf1hbz7aw1kx4";
  }) {nixpkgs=nixpkgs;};

}
