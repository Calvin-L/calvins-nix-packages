{stdenvNoCC, fetchurl, lib, python3}:

stdenvNoCC.mkDerivation rec {
  pname = "many-smt";
  version = "1.0.0";
  src = fetchurl {
    url = "https://github.com/Calvin-L/many-smt/archive/refs/tags/v${version}.tar.gz";
    sha256 = "b33902cb95edb437e453c81501cd8251290a3d9b748d9d4e83a40736fde2705f";
  };
  buildInputs = [
    python3
  ];
  installPhase = ''
    mkdir -p "$out/bin"
    substituteInPlace many-smt --replace '#!/usr/bin/env python3' '#!${python3}/bin/python'
    cp many-smt "$out/bin/"
    chmod 0555 "$out/bin/many-smt"
  '';
  meta = {
    homepage = https://github.com/Calvin-L/many-smt;
    description = "An SMT frontend that runs multiple backend solvers in parallel, returning the first result";
    license = lib.licenses.mit;
  };
}
