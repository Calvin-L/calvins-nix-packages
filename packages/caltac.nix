{coqPackages, lib, fetchFromGitHub, coqhammer-tactics}:

coqPackages.mkCoqDerivation {

  pname = "caltac";
  owner = "Calvin-L";
  version = "0.1";

  fetcher = {owner, repo, ...}: fetchFromGitHub {
    inherit owner repo;
    rev = "11028f339b460531d69c332d0c4fe72e2172caeb";
    hash = "sha256-AU55/hCrgh0ovBvGM1LZ2iXNVGNx7NEcwcxZERN+jNM=";
  };

  nativeBuildInputs = [
    coqPackages.coq.ocamlPackages.findlib
  ];

  propagatedBuildInputs = [
    coqhammer-tactics
  ];

  meta = {
    description = "A highly-opinionated set of Coq tactics";
    license = lib.licenses.mit;
  };

}
