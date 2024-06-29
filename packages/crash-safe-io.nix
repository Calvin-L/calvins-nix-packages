{lib, buildJavaPackage, fetchFromGitHub, checker-qual}:

buildJavaPackage rec {
  pname = "crash-safe-io";
  version = "0.1";
  license = lib.licenses.mit;
  src = fetchFromGitHub {
    owner = "Calvin-L";
    repo = pname;
    rev = "4a744b9f2b8f1d5cbcb841d738497fcfd9ff7756";
    hash = "sha256-4WYN7cGSNXrdwbmVw+Vyqj1Je+AKIoqFK9UwCzEEyJ8=";
  };
  compileOnlyDeps = [
    checker-qual
  ];
}
