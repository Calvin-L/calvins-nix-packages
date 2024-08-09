import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0ee61304eb44477b6ecd78774d86e431c0b10e5b.tar.gz";
    sha256 = "1svbp56bpw76sgb2pqi13f4z2nlk772vgwz24y8yg79brykadf7y";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/78710548665da11cf69d08fa4586dead4dda0695.tar.gz";
    sha256 = "0i7nv07a34kh801kff15av8c4rpdydw02v23la7wf1hbz7aw1kx4";
  }) {nixpkgs=nixpkgs;};

}
