{ lib, stdenvNoCC, fetchFromGitHub,
  writeShellApplication,
  tla-community-modules,
  # core tools
  ocamlPackages,
  bash,
  ps,
  darwin,
  sysctl,
  unzip,
  # solvers
  z3,
  yices,
  cvc4,
  isabelle,
  zenon,
  ls4,
  zipperposition }:

let

version = "2026.7.31";

src = fetchFromGitHub {
  owner = "tlaplus";
  repo = "tlapm";
  rev = "4600b24c6d95a25ff081ad37b63b2a01c29d43a5";
  hash = "sha256-qRrKoL9aJ9anF72cNMTIwwcdLfMAlsLKE8I/pvYo4xs=";
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
  text = ''
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

    COMMUNITY_MODULES_JAR="$(find ${lib.strings.escapeShellArg tla-community-modules} -iname '*.jar')"

    substituteInPlace library/dune --replace-fail \
      'run "wget" "https://github.com/tlaplus/CommunityModules/releases/latest/download/CommunityModules.jar"' \
      'run "cp" "-v" "--reflink=auto" "'"$COMMUNITY_MODULES_JAR"'" "CommunityModules.jar"'
  '';

  nativeBuildInputs = [
    unzip
  ] ++ lib.optionals (stdenvNoCC.isDarwin) [
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
