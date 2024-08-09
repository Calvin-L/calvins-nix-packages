{ lib, stdenvNoCC, fetchFromGitHub,
  writeShellApplication,
  # core tools
  ocamlPackages, bash,
  # solvers
  z3, yices, cvc4, isabelle_2011, isabelle_2011_pure, zenon,
  ls4, ptl-to-trp-translator, zipperposition, ps,
  darwin }:

let

version = "2024.6.11";

src = fetchFromGitHub {
  owner = "tlaplus";
  repo = "tlapm";
  rev = "117b5cb1fc0734a5667d6c415cf0a9aee978792b";
  hash = "sha256-eMuJ20M0sBrF3/VUtTGtFqAdHayAW3VQTaXc3ZJPeDc=";
};

heap_dirname = "Isabelle${isabelle_2011.version}";

isabelle_2011_tlaplus = stdenvNoCC.mkDerivation {
  pname = "${isabelle_2011.name}-tlaplus";
  inherit version;
  inherit src;

  buildInputs = [
    isabelle_2011
    isabelle_2011_pure
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    export HOME="$(pwd)/tmp_home"
    make -C isabelle heap-only
  '';

  installPhase = ''
    mkdir -p $out
    cp -R tmp_home/.isabelle/${heap_dirname}/heaps $out/
    echo '--- deleting logs'
    find $out -type d -name log -exec rm -rfv {} +
  '';

  setupHook = ./isabelle-theory-setup-hook.sh;
};

tlapm = ocamlPackages.buildDunePackage {
  pname = "tlapm";
  inherit version;
  inherit src;

  postPatch = ''
    rm -r deps

    substituteInPlace src/params.ml --replace-fail \
'let library_path =
  let d = Sys.executable_name in
  let d = Filename.dirname (Filename.dirname d) in
  let d = Filename.concat d "lib" in
  let d = Filename.concat d "tlaps" in
  d' \
    'let library_path = "'"$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/tlapm/stdlib"'"'
  '';

  nativeBuildInputs = lib.optionals (stdenvNoCC.isDarwin) [
    darwin.sigtool
  ];

  buildInputs = [
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
    isabelle_2011
    zenon
    ptl-to-trp-translator
    ls4
    zipperposition
    ps
  ];

  runtimeEnv = {
    ISABELLE_PATH = "${isabelle_2011_pure}/heaps:${isabelle_2011_tlaplus}/heaps";
  };

  text = ''
    exec ${tlapm}/bin/tlapm "$@"
  '';

  derivationArgs = {
    meta = tlapm.meta;
  };
}
