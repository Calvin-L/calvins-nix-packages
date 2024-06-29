{lib, stdenv, fetchurl, binutils, flex, texinfo, which, unzip, help2man, file,
 libtool, ncurses, intltool, python3, bison, subversion, git, wget, curl,
 libiconv}:

stdenv.mkDerivation rec {
  name = "crosstool-ng-${version}";
  version = "1.24.0";
  src = fetchurl {
    url = "http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-${version}.tar.xz";
    sha512 = "89b8794a4184ad4928750e29712ed4f194aa1d0b93768d67ff64f30c30f1b1e165647cafc6de94d68d3ef70e50446e544dad65aa36137511a32ee7a667dddfb4";
  };

  buildInputs = [
    binutils
    flex
    texinfo
    which
    unzip
    help2man
    file
    libtool
    ncurses
    intltool
  ] ++ [
    # optional?
    # the configure script looks for these, but succeeds without them...
    python3
    bison
    subversion
    git
    wget
    curl.bin
    libiconv
  ];

  meta = {
    homepage = "https://crosstool-ng.github.io/";
    description = "Versatile (cross-)toolchain generator";
    license = lib.licenses.gpl2;
  };
}
