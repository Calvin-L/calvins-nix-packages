{lib, stdenvNoCC, fetchFromGitHub, jre, jdk, scala, sbt}:

stdenvNoCC.mkDerivation rec {
  pname = "apalache";
  version = "0.47.2";

  meta = with lib; {
    description = "Symbolic model checker for TLA+";
    homepage = "https://apalache.informal.systems/";
    changelog = "https://github.com/informalsystems/apalache/blob/v${version}/CHANGES.md";
    license = licenses.asl20;
  };

  src = fetchFromGitHub {
    owner = "informalsystems";
    repo = "apalache";
    rev = "v${version}";
    hash = "sha256-CwX96caTGDSvxx5PA7Qu+ROwmQ6Y9sWrTbtEOEZBUak=";
  };

  nativeBuildInputs = [
    jdk
    scala
    sbt
  ];

  #  > Patch the build.sbt file so that it does not call the `git describe` command.
  #  > This is called by sbt-derivation to resolve the Scala dependencies, however
  #  > inside the Nix build environment for sbt-derivation, the git command is
  #  > not available, hence the dependency resolution would fail. As a workaround,
  #  > we use the version string provided in Nix as the build version.
  # https://github.com/informalsystems/cosmos.nix/blob/f027e5b304e8a1593a0da8677dfea5bef1a95f02/packages/apalache.nix#L8
  #
  # Plus my own adjustments to hardcode paths in apalache-mc script.
  postPatch = ''
    substituteInPlace ./build.sbt \
      --replace-fail 'Process("git describe --tags --always").!!.trim' '"${version}"'

    substituteInPlace src/universal/bin/apalache-mc \
      --replace-fail 'SOURCE=''${BASH_SOURCE[0]}
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )' "DIR='$out/bin'" \
      --replace-fail 'APALACHE_JAR=''${APALACHE_JAR:-"$DIR/../lib/apalache.jar"}' "APALACHE_JAR='$out/lib/apalache.jar'" \
      --replace-fail 'exec java ' 'exec ${jre}/bin/java '
  '';

  buildPhase = ''
    export HOME="$(mktemp -d)"
    export SBT_OPTS="-Duser.home=$HOME"
    make dist
  '';

  installPhase = ''
    mkdir unpack
    cd unpack
    tar xf ../target/universal/apalache.tgz

    rm apalache/bin/apalache-mc.bat

    mkdir -p "$out"
    mv apalache/bin "$out"
    mv apalache/lib "$out"
  '';

}
