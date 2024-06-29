{lib, stdenvNoCC, fetchurl, polyml, hostname, perl, jre, rlwrap}:

stdenvNoCC.mkDerivation rec {
  name = "isabelle-${version}";
  version = "2011-1";
  dirname = "Isabelle${version}";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/website-${dirname}/dist/${dirname}.tar.gz";
    sha256 = "48d77fe31a16b44f6015aa7953a60bdad8fcec9e60847630dc7b98c053edfc08";
  };

  outputs = ["bin" "home" "out" "doc"];

  nativeBuildInputs = [
    hostname # used by build script
  ];

  buildInputs = [
    polyml
    perl
    jre
    rlwrap
  ];

  sourceRoot = dirname;

  patches = [
    ./isabelle_2011_fixes.patch
  ];

  postPatch = ''
    patchShebangs "."

    substituteInPlace etc/settings --replace '/path/to/polyml/bin' '${polyml}/bin'
    substituteInPlace etc/settings --replace '/path/to/java/bin' '${jre}/bin'
    substituteInPlace etc/settings --replace '/path/to/rlwrap/bin' '${rlwrap}/bin'

    substituteInPlace bin/isabelle \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace bin/isabelle-process \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/scripts/feeder \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/scripts/timestart.bash \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/Tools/getenv \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/Tools/latex \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/Tools/logo \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace lib/Tools/dimacs2hol \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace src/Tools/Code/lib/Tools/codegen \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace src/Tools/Metis/fix_metis_license \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace src/Tools/Metis/make_metis \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace src/Tools/jEdit/lib/Tools/jedit \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace src/HOL/Mirabelle/lib/Tools/mirabelle \
      --replace 'perl' "${perl}/bin/perl"

    substituteInPlace etc/settings --replace \
      'ISABELLE_PATH="$ISABELLE_HOME_USER/heaps:$ISABELLE_HOME/heaps"' \
      'ISABELLE_PATH="$ISABELLE_PATH:$ISABELLE_HOME_USER/heaps:$ISABELLE_HOME/heaps"'
  '';

  # remove a bunch of crap (https://github.com/tlaplus/tlapm/blob/581ebd8afbe927b2b7d31c62ccec3a3409d9d8ce/tools/installer/tlaps-release.sh.in#L135)
  # rm -rf contrib lib/{classes,fonts,logo,icons,ProofGeneral,html}

#   buildPhase = ''
# #    export HOME="$(pwd)/tmp_home"
# #    mkdir -p "$HOME"
#     bash -e ./build -b Pure
# #    ./bin/isabelle make -C 'src/Pure'
#     ls -la
#   '';

  installPhase = ''
    # install doc
    mkdir -p $doc/share/doc
    mv doc $doc/share/doc/${dirname}

    # install home (i.e. basically everything)
    mkdir -p $home
    mv * $home

    # install everything else
    mkdir -p $bin/bin
    $home/bin/isabelle install -d "$home" -p "$bin/bin"
  '';

  meta = {
    homepage = "https://isabelle.in.tum.de/website-Isabelle2011-1/";
    description = "Proof assistant";
    license = lib.licenses.bsd3; # "Isabelle is distributed for free under the BSD license."
  };
}
