{ lib, stdenvNoCC, fetchFromGitHub, fetchurl,
  tla-community-modules,
  tlapm-isabelle-theory,
  ocamlPackages,
  darwin,
  unzip }:

ocamlPackages.buildDunePackage {
  pname = "tlapm";
  version = "2026.7.31";
  src = fetchFromGitHub {
    owner = "tlaplus";
    repo = "tlapm";
    rev = "4600b24c6d95a25ff081ad37b63b2a01c29d43a5";
    hash = "sha256-qRrKoL9aJ9anF72cNMTIwwcdLfMAlsLKE8I/pvYo4xs=";
  };

  patches = [
    # perf fixes from https://github.com/tlaplus/tlapm/issues/286
    # I manually audited all of these on 2026/9/1.
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/5c1ae25a5ea7916926f9f9639f284d5cc2341fd9.patch"; hash = "sha256-JTE3Lp7aFHD0FEnZyj26fcOL5Qpz31crT77xB+/AFuo="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/e360684c9bdb09d741b8d3749cacbdb47eddaca1.patch"; hash = "sha256-ka+b3Jczs8Sjvu+OtCUd2k/UW41+E+DQxKji5nyDrQo="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/4cc3aeab5972b14ceb4dbd7f0d4dfd7678038518.patch"; hash = "sha256-JDXyhiKwuDWKzAN5SE/PCrZJod80rU8qfBKO9D5iQJE="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/6bb4a0bfde7decc443f3e7190b81022e8d0a6de7.patch"; hash = "sha256-X3ogzaaBSlLRODaTVnB7qYY17EF/WOxgQ0IHYmXIvPQ="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/9f9c5cf0ed711b0d7863594024a25b69a5374772.patch"; hash = "sha256-zhmnuI4qau3+3XokErlyCiSS+1S+zn+DNXULKAERuos="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/01d37869fd0c1be673d8acb5976768aa3677f0c6.patch"; hash = "sha256-ENrErgiAfz4cDSlHmFiMVkJS2jD7lbU6mHSi3CjyOw8="; })
    (fetchurl { url = "https://github.com/qdelamea-aneo/tlapm/commit/edd012962e27e1a68a0f5714d263436f6d1dd3cf.patch"; hash = "sha256-p1UZzl1B9HxZLYSl2I/++I0WGM+RwRiV5pD7aLjXc/Y="; })
  ];

  postPatch = ''
# <-- for indentation
    rm -r deps

    substituteInPlace src/params.ml --replace-fail \
      'let isabelle_tla_path =
  List.fold_left Filename.concat isabelle_base_path ["src"; "TLA+"]' \
      'let isabelle_tla_path = "${tlapm-isabelle-theory}/src"'

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
}
