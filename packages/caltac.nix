{coqPackages, lib, fetchFromGitHub, coqhammer-tactics}:

coqPackages.mkCoqDerivation {

  pname = "caltac";
  owner = "Calvin-L";
  version = "0.1";

  fetcher = {owner, repo, ...}: fetchFromGitHub {
    inherit owner repo;
    rev = "41badb91eba40638e99688adcaf05422c625e1d2";
    hash = "sha256-6zrHTKNTqkUqni8QG6gy6oNZzJdNUXjnyXEC3BzmKmc=";
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
