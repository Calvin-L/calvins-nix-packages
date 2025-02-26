{ lib, stdenvNoCC, fetchFromGitHub,
  writeShellApplication,
  # core tools
  ocamlPackages,
  bash,
  ps,
  darwin,
  # solvers
  z3,
  yices,
  cvc4,
  isabelle,
  zenon,
  ls4,
  # ptl-to-trp-translator, # now ships as part of TLAPS
  zipperposition }:

let

version = "2025.2.17";

src = fetchFromGitHub {
  owner = "tlaplus";
  repo = "tlapm";
  rev = "12015392f5ee30d737bf826efccc68603c2e3c53";
  hash = "sha256-Az+kL71RVpZbbACAd+RMu0XUoChlfLEMBi+v91iPDoU=";
};

isabelle-theory = stdenvNoCC.mkDerivation {
  pname = "${isabelle.name}-tlaplus";
  inherit version;
  inherit src;

  buildInputs = [
    isabelle
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    export HOME="$(pwd)/tmp_home"
    mkdir -p "$HOME"
    make -C isabelle heap-only
  '';

  installPhase = ''
    mkdir -p $out/src
    cp --reflink=auto -rv isabelle/* $out/src/

    mkdir -p $out/home
    cp -R tmp_home/.isabelle $out/home/
    echo '--- deleting logs'
    find $out/home -type d -name log -exec rm -rfv {} +
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME="$out/home" isabelle process -e '(writeln "OK")' -d "$out/src" -l TLA+
  '';
};

tlapm = ocamlPackages.buildDunePackage {
  pname = "tlapm";
  inherit version;
  inherit src;

  postPatch = ''
# <-- for indentation
    rm -r deps

    substituteInPlace src/params.ml --replace-fail \
      'let isabelle_tla_path =
  List.fold_left Filename.concat isabelle_base_path ["src"; "TLA+"]' \
      'let isabelle_tla_path = "${isabelle-theory}/src"'

    substituteInPlace src/params.ml --replace-fail \
      '"isabelle process -e' \
      '"HOME=${isabelle-theory}/home isabelle process -e'
  '';

  nativeBuildInputs = lib.optionals (stdenvNoCC.isDarwin) [
    darwin.sigtool
  ];

  buildInputs = [
    ocamlPackages.camlzip
    ocamlPackages.cmdliner
    ocamlPackages.sexplib
    ocamlPackages.ppx_inline_test
    ocamlPackages.ppx_assert
    ocamlPackages.dune-build-info
    ocamlPackages.dune-site
  ];

  meta = {
    description = "Mechanically check TLA+ proofs";
    longDescription = ''
      TLA+ is a general-purpose formal specification language that is
      particularly useful for describing concurrent and distributed
      systems. The TLA+ proof language is declarative, hierarchical,
      and scalable to large system specifications. It provides a
      consistent abstraction over the various "backend" verifiers.
    '';
    homepage    = "https://tla.msr-inria.inria.fr/tlaps/content/Home.html";
    license     = lib.licenses.bsd2;
    platforms   = lib.platforms.unix;
  };
};

in

writeShellApplication {
  name = "tlapm";
  runtimeInputs = [
    bash
    z3
    yices
    cvc4
    isabelle
    zenon
    # ptl-to-trp-translator
    tlapm # ptl-to-trp-translator has moved to tlapm/bin
    ls4
    zipperposition
    ps
  ];

  text = ''
    exec ${tlapm}/bin/tlapm "$@"
  '';

  derivationArgs = {
    meta = tlapm.meta;
  };
}
