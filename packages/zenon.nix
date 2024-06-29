{lib, stdenv, fetchFromGitHub, ocaml}:

stdenv.mkDerivation rec {
  name = "zenon-${version}";
  version = "0.8.5";
  src = fetchFromGitHub {
    owner = "zenon-prover";
    repo = "zenon";
    rev = "${version}";
    hash = "sha256-j3KEtlMebYAQ13DT8Lz+vjcP6AzOmGevGDOY145Qmqs=";
  };
  enableParallelBuilding = false; # parallel build is broken
  nativeBuildInputs = [
    ocaml
  ];
  configurePhase = "./configure --prefix $out";
  meta = {
    homepage = http://www.zenon-prover.org;
    license = lib.licenses.bsd3;
    description = "An extensible automated theorem prover producing checkable proofs";
  };
}
