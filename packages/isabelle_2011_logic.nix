{ stdenvNoCC, fetchurl,
  isabelle_2011,
  logic_name,
  extra_inputs ? [] }:

stdenvNoCC.mkDerivation rec {
  name = "isabelle-${version}-${logic_name}";
  version = "2011-1";
  dirname = "Isabelle${version}";

  src = isabelle_2011.src;

  nativeBuildInputs = [isabelle_2011];
  buildInputs = extra_inputs;

  sourceRoot = dirname;

  patches = [
    ./isabelle_2011_fixes.patch
  ];

  postPatch = ''
    patchShebangs --build src/${logic_name}
  '';

  # By default, Isabelle puts outputs in $HOME/.isabelle/...  Very impure!
  # Its own ./build script circumvents that behavior to put outputs in the
  # source root, and this is more or less the dance it does to achieve that.
  # Note that I don't want to use ./build directly since it invokes Isabelle
  # out of the current source tree, not using the installed binaries.
  #
  # The way this works is to directly source `getsettings`, which sets a magic
  # flag to prevent itself from being re-loaded when we invoke `isabelle`,
  # which means we can override variables that are normally unconditionally set
  # by `getsettings`.
  buildPhase = ''
    export ISABELLE_HOME='${isabelle_2011.home}'
    source "$ISABELLE_HOME/lib/scripts/getsettings"
    export ISABELLE_OUTPUT="$out/heaps/$ML_IDENTIFIER"
    mkdir -p "$ISABELLE_OUTPUT"
    isabelle make -C 'src/${logic_name}'
  '';

  installPhase = "true";

  postInstall = ''
    echo '--- deleting logs'
    find $out -type d -name log -print0 | xargs -0 -- rm -rfv
  '';

  setupHook = ./isabelle-theory-setup-hook.sh;

  meta = {
    license = isabelle_2011.meta.license;
  };
}
