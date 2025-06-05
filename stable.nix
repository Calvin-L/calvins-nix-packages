import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e4b09e47ace7d87de083786b404bf232eb6c89d8.tar.gz";
    sha256 = "1a2qvp2yz8j1jcggl1yvqmdxicbdqq58nv7hihmw3bzg9cjyqm26";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/78710548665da11cf69d08fa4586dead4dda0695.tar.gz";
    sha256 = "0i7nv07a34kh801kff15av8c4rpdydw02v23la7wf1hbz7aw1kx4";
  }) {nixpkgs=nixpkgs;};

}
