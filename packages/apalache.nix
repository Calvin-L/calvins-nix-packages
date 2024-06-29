{lib, stdenvNoCC, fetchFromGitHub, jdk, scala, sbt, git}:

stdenvNoCC.mkDerivation rec {
  pname = "apalache";
  version = "0.44.10";

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
    hash = "sha256-IpvGB8+ZHOrKQJ/9j7iyV2QQtIqGRp0pljuxWMZ8Zxk=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    jdk
    scala
    sbt
    git
  ];

  buildPhase = ''
    export HOME="$(mktemp -d)"
    export SBT_OPTS="-Duser.home=$HOME"
    make dist
  '';

  installPhase = ''
    mkdir unpack
    cd unpack
    tar xf ../target/universal/apalache.tgz

    mkdir -p "$out"
    mv apalache/bin "$out"
    mv apalache/lib "$out"
  '';

}
