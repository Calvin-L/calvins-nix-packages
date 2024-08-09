import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/0ee61304eb44477b6ecd78774d86e431c0b10e5b.tar.gz";
    sha256 = "1svbp56bpw76sgb2pqi13f4z2nlk772vgwz24y8yg79brykadf7y";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/36f19d336e00d45c8f2636b4938b962277c02c2d.tar.gz";
    sha256 = "0l5n1iky7nl6gqfbksfkvp24lmi9c1l81ci7lpyspa2fffp50blv";
  }) {nixpkgs=nixpkgs;};

}
