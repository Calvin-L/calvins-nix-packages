{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "retry-forever";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "Calvin-L";
    repo = "retry-forever";
    rev = "076fdc60109ae78c214032be9c32f1faf43e3b9c";
    hash = "sha256-jfBcifKXB5Qf0jPz5lgzNvAuJLE1ZERHA4IE5DYEjvM=";
  };
  nativeBuildInputs = [
    cmake
  ];
  meta = {
    homepage = https://github.com/Calvin-L/retry-forever;
    description = "Retry a process forever";
    license = lib.licenses.mit;
  };
}
