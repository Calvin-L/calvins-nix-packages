{lib, stdenv, fetchurl, ocaml, bash, binutils}:

# https://groups.google.com/forum/#!topic/tlaplus/NWego1cKCnA
stdenv.mkDerivation rec {
  name = "ptl-to-trp-translator"; # unversioned
  src = fetchurl {
    url = "https://cgi.csc.liv.ac.uk/%7Ekonev/software/trp++/translator/translate.tar.bz2";
    sha256 = "0sg59i88w4aiglnydygl3894k50j7qslps14jdipai8xwz45qkr3";
  };
  buildInputs = [
    ocaml
    bash
    binutils
  ];
  patchPhase = ''
    rm -v {fo,}translate{.bin,}
    patchShebangs --build .
  '';
  buildPhase = ''
    ./buildAll.sh
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp translate.bin $out/bin/translate
    cp translate.bin $out/bin/ptl_to_trp
  '';
  meta = {
    homepage = https://cgi.csc.liv.ac.uk/~konev/software/trp++/;
    description = "A translator from the PTL syntax to the TRP++ format";
    license = lib.licenses.gpl2;
  };
}
