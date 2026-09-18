{ stdenvNoCC,
  isabelle,
  tlapm-unwrapped }:

stdenvNoCC.mkDerivation {
  pname = "${isabelle.name}-tlaplus";
  inherit (tlapm-unwrapped) version src;

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
}
