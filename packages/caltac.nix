{coqPackages, lib, fetchFromGitHub, coqhammer-tactics}:

coqPackages.mkCoqDerivation {

  pname = "caltac";
  owner = "Calvin-L";
  version = "0.1";

  fetcher = {owner, repo, ...}: fetchFromGitHub {
    inherit owner repo;
    rev = "71790c15e6637ea3bcf39197f9a9a01c0c708d24";
    hash = "sha256-mGHkdoOw+cTa6JXnd9CJF2UMOcf9CG9W+n06FKRMJQk=";
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
