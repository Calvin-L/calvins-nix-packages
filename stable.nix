import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/dad564433178067be1fbdfcce23b546254b6d641.tar.gz";
    sha256 = "0s5z920v4y6d5jb7kpqjsc489sls7glg9ybvbb5m37k7gkjbqzdy";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/78710548665da11cf69d08fa4586dead4dda0695.tar.gz";
    sha256 = "0i7nv07a34kh801kff15av8c4rpdydw02v23la7wf1hbz7aw1kx4";
  }) {nixpkgs=nixpkgs;};

}
