{lib, stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  pname = "retry-forever";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "Calvin-L";
    repo = "retry-forever";
    rev = "347ea21bcc9a422b11f1c41f3d960aacd3cfd671";
    sha256 = "14k1z875fgannj5z0w2k25d97pd2i9vhpc2walmpbb44l9bij7yr";
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
