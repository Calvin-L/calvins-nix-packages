{lib, stdenv, fetchurl, fetchFromGitHub, fetchFromGitLab, ocamlPackages}:

let

ocamlPackages_downgraded = ocamlPackages.overrideScope (final: prev: {

  mtime = stdenv.mkDerivation rec {
    pname = "ocaml${final.ocaml.version}-mtime";
    version = "1.4.0";

    src = fetchurl {
      url = "https://erratique.ch/software/mtime/releases/mtime-${version}.tbz";
      sha256 = "VQyYEk8+57Yq8SUuYossaQUHZKqemHDJtf4LK8qjxvc=";
    };

    nativeBuildInputs = [ final.ocaml final.findlib final.ocamlbuild final.topkg ];
    buildInputs = [ final.topkg ];

    strictDeps = true;

    inherit (final.topkg) buildPhase installPhase;
    meta = with lib; {
      description = "Monotonic wall-clock time for OCaml";
      homepage = "https://erratique.ch/software/mtime";
      inherit (final.ocaml.meta) platforms;
      license = licenses.bsd3;
    };
  };

  oseq = prev.oseq.overrideAttrs (_: rec {
    version = "0.3";
    src = fetchFromGitHub {
      owner = "c-cube";
      repo = "oseq";
      rev = version;
      hash = "sha256-vCwLjoFm0xzLa4iQ4iVmLkREF90s9aooWC44Aazu3sY=";
    };
    checkInputs = [
      final.containers
      final.qtest
    ];
    nativeCheckInputs = [
      final.qtest
    ];
  });

  # This will also alter menhir*
  menhirLib = prev.menhirLib.overrideAttrs (prev: rec {
    version = "20210928";
    name = "${prev.pname}-${version}";
    src = fetchFromGitLab {
      domain = "gitlab.inria.fr";
      owner = "fpottier";
      repo = "menhir";
      rev = version;
      hash = "sha256-6t3LXVgZfcEBxeCPDbdEeEBPFrnCvEJfluCHTcoPr/A=";
    };
  });

});

version = "2.1";
src = fetchFromGitHub {
  owner = "sneeuwballen";
  repo = "zipperposition";
  rev = version;
  hash = "sha256-FHNl4kXQ1JMNQ78LUTOvwiYZIOjPZKrh6C4VJwlSJOs=";
};
meta-common = {
  homepage = "https://sneeuwballen.github.io/zipperposition/";
  license  = lib.licenses.bsd2;
};

logtk = with ocamlPackages_downgraded; buildDunePackage {
  pname = "logtk";
  inherit version src;

  duneVersion = "3";

  nativeBuildInputs = [
    menhir
  ];

  buildInputs = [
    containers
    containers-data
    iter
    mtime
    oseq
    zarith
  ];

  checkInputs = [
    alcotest
    qcheck-alcotest
    qcheck-core
  ];

  meta = meta-common;
};

libzipperposition = with ocamlPackages_downgraded; buildDunePackage {
  pname = "libzipperposition";
  inherit version src;

  duneVersion = "3";

  buildInputs = [
    containers
    containers-data
    iter
    logtk
    msat
    mtime
    oseq
    zarith
  ];

  meta = meta-common;
};

in

with ocamlPackages_downgraded; buildDunePackage {
  pname = "zipperposition";
  inherit version src;

  duneVersion = "3";

  buildInputs = [
    containers-data
    iter
    libzipperposition
    logtk
    msat
    mtime
    oseq
    zarith
  ];

  meta = meta-common // {
    description = "Automatic theorem prover";
    longDescription = ''
       An automatic theorem prover in OCaml for typed higher-order logic with
       equality and datatypes, based on superposition+rewriting; and Logtk, a
       supporting library for manipulating terms, formulas, clauses, etc.
    '';
  };
}
