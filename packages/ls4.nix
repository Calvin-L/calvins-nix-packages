{lib, stdenv, fetchFromGitHub, zlib}:

# The difficult-to-track-down "ls4" modal logic solver that tlaps wants.
# Homepage of Martin Suda, the author:
#  http://www.cs.man.ac.uk/~sudam/
#  https://forsyte.at/people/suda/
#  https://scholar.google.com/citations?hl=en&user=O0zcIe0AAAAJ
# Homepage of the tool, now defunct:
#  http://www.mpi-inf.mpg.de/~suda/ls4.html
# Github page, fortunately still up:
#  https://github.com/quickbeam123/ls4
# The original paper about ls4, titled "A PLTL-Prover Based on Labelled
# Superposition with Partial Model Guidance" (2012, Martin Suda and
# Christoph Weidenbach):
# https://www.researchgate.net/publication/262289815_A_PLTL-Prover_Based_on_Labelled_Superposition_with_Partial_Model_Guidance
stdenv.mkDerivation rec {
  pname = "ls4";
  version = "1.1";
  src = fetchFromGitHub {
    owner = "quickbeam123";
    repo = "ls4";
    rev = "ls4_v1.1";
    hash = "sha256-zuxiA2RG2JDAeKtKqSQ0ukrszCJpnWGLpNeEBn6bNKw=";
  };
  buildInputs = [
    zlib
  ];
  patches = [
    # See: see https://github.com/sambayless/monosat/issues/33
    # See: https://github.com/niklasso/minisat/commit/93b181009d4410812abd142be18ad82283fb7dd5
    ./ls4_guard_use_of_fpu.patch

    # Fix build with Clang due to illegal string concatenation:
    #   Making dependencies
    #   In file included from /private/var/folders/k0/tw__ldzn7r19gby9d93tffh40000gn/T/nix-build-ls4-1.0.drv-0/source/core/Main.cc:34:
    #   ../utils/Options.h:285:33: error: invalid suffix on literal; C++11 requires a space between literal and identifier [-Wreserved-user-defined-literal]
    #               fprintf(stderr, "%4"PRIi64, range.begin);
    #                                   ^
    #
    #   ../utils/Options.h:291:33: error: invalid suffix on literal; C++11 requires a space between literal and identifier [-Wreserved-user-defined-literal]
    #               fprintf(stderr, "%4"PRIi64, range.end);
    #                                   ^
    #
    #   ../utils/Options.h:293:40: error: invalid suffix on literal; C++11 requires a space between literal and identifier [-Wreserved-user-defined-literal]
    #           fprintf(stderr, "] (default: %"PRIi64")\n", value);
    #                                          ^
    #
    #   3 errors generated.
    #   make: *** [../mtl/template.mk:72: /private/var/folders/k0/tw__ldzn7r19gby9d93tffh40000gn/T/nix-build-ls4-1.0.drv-0/source/core/Main.o] Error 1
    ./ls4_whitespace_around_string_concat.patch
  ];
  enableParallelBuilding = true;
  preBuild = ''
    cd core
    rm -f *.o *.o_32
    make aiger.o
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp ls4 $out/bin/
  '';
  meta = {
    homepage = https://github.com/quickbeam123/ls4;
    description = "A PLTL-prover based on labelled superposition";
    license = lib.licenses.mit;
  };
}
