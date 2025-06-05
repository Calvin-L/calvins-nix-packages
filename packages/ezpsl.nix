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
    rev = "a9927f0285fdae32d90bf8e23d25f03f18afd9ba";
    hash = "sha256-CHlNn3nZWBB3SbuM3DdJnqIhxPEQt1n7+5tPEEaUzfI=";
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
