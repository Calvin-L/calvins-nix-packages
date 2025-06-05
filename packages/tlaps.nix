{ lib, stdenvNoCC, fetchFromGitHub,
  writeShellApplication,
  # core tools
  ocamlPackages,
  bash,
  ps,
  darwin,
  sysctl,
  # solvers
  z3,
  yices,
  cvc4,
  isabelle,
  zenon,
  ls4,
  zipperposition }:

let

version = "2025.6.3";

src = fetchFromGitHub {
  owner = "tlaplus";
  repo = "tlapm";
  rev = "e9b8bb51818f0b454384e8d94fe614899a0aaa78";
  hash = "sha256-Z15dbuncsAC7R9vF3eosm+ibuXWcL5xHfaLAqTTNBZI=";
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

isabelle-wrapper = writeShellApplication {
  name = "isabelle";
  runtimeInputs = [
    isabelle
    sysctl #!? WTF Isabelle...
  ];
  # TODO: fix Isabelle's broken temporary file strategy (doesn't work when multiple users are involved...)
  text = ''
    if [[ -d /tmp/isabelle- ]] && ! touch /tmp/isabelle-/foo; then
      echo 'Temporary directory /tmp/isabelle- is not writable (did Nix take ownership??)' >&2
      exit 1
    fi
    export HOME='${isabelle-theory}/home'
    exec isabelle "$@"
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
    ocamlPackages.ppx_deriving
    ocamlPackages.dune-build-info
    ocamlPackages.dune-site
  ];

  # ????
  postInstall = ''
    mv $out/bin/translate $out/bin/ptl_to_trp
  '';

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
    isabelle-wrapper
    zenon
    tlapm
    ls4
    zipperposition
    ps
  ];

  text = ''
    exec tlapm "$@"
  '';

  derivationArgs = {
    meta = tlapm.meta;
  };
}
