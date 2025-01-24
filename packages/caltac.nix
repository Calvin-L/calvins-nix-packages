{coqPackages, lib, fetchFromGitHub, coqhammer-tactics}:

coqPackages.mkCoqDerivation {

  pname = "caltac";
  owner = "Calvin-L";
  version = "0.1";

  fetcher = {owner, repo, ...}: fetchFromGitHub {
    inherit owner repo;
    rev = "7c5454b3f73f9d6e621f7c6e90e87271bbe6ee31";
    hash = "sha256-bi/Wu16mT1CeLq2VjqJzQ12tlV0YLEpGJIu3VaLNrrU=";
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
