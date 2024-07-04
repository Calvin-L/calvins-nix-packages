import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0aeab749216e4c073cece5d34bc01b79e717c3e0.tar.gz";
    sha256 = "0fnw58pxb9l2iskrcr7d03vkbzf19qqb23r7w0ds2a62wclzxc6h";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/36f19d336e00d45c8f2636b4938b962277c02c2d.tar.gz";
    sha256 = "0l5n1iky7nl6gqfbksfkvp24lmi9c1l81ci7lpyspa2fffp50blv";
  }) {nixpkgs=nixpkgs;};

}
