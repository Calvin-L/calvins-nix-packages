import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/abd6d48f8c77.tar.gz";
    sha256 = "0lisfh5b3dgcjb083nsxmffvzxzs6ir1jfsxfaf29gjpjnv7sm7f";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/adbc4e3ff414009b54b7616c00d7781f3e9cb548.tar.gz";
    sha256 = "1jklkdky2d4y42ljd0nj5la1x6al92zm39sk9h367zrazn8140lc";
  }) {nixpkgs=nixpkgs;};

}
