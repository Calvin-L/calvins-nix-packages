{lib, haskellPackages, tlatools, fetchFromGitHub}:

haskellPackages.mkDerivation rec {
  pname = "ezpsl";
  version = "0.1";
  homepage = "https://github.com/Calvin-L/ezpsl";
  description = "The easy parallel algorithm specification language";
  license = lib.licenses.mit;

  src = fetchFromGitHub {
    owner = "Calvin-L";
    repo = pname;
    rev = "031f9679c1bc1fe9390f6601cff65e4c208ec4b5";
    hash = "sha256-7wrg4GLsU9kagm9OPMV9c265EFv/eAMrWKcGt8dlcZo=";
  };

  enableSeparateBinOutput = true;
  enableParallelBuilding  = true;

  buildTools = [haskellPackages.hpack];

  libraryToolDepends = with haskellPackages; [
    alex
    happy
  ];

  libraryHaskellDepends = with haskellPackages; [
    array
    containers
    mtl
    directory
    temporary
    filepath
  ];

  executableHaskellDepends = with haskellPackages; [
    filepath
  ];

  testHaskellDepends = with haskellPackages; [
    hspec
    directory
    temporary
    process
  ];

  testToolDepends = [
    tlatools
  ];

  preConfigure = "hpack";
}
