{ coqPackages, coqhammer-tactics, version ? null }:

let lib = coqPackages.lib; in
let coq = coqPackages.coq; in

coqPackages.mkCoqDerivation {
  inherit version;
  pname = "coqhammer";
  owner = "lukaszcz";
  defaultVersion = lib.switch coq.coq-version [
    { case = "8.18"; out = "1.3.2+8.18"; }
    { case = "8.19"; out = "1.3.2+8.19"; }
    { case = "8.20"; out = "1.3.2+8.20"; }
  ] null;
  release = {
    "1.3.2+8.18".sha256 = "4c619b72bed0963436eca485bfceda8448790e8cd128292385a970190c0eed6a";
    "1.3.2+8.19".sha256 = "ecc176131220dad97878280cafde346caad30d8fb558b82e2ea89f13cc827e01";
    "1.3.2+8.20".sha256 = "07iv59bb8z8kg8b6j0w3z8h9q6ipmj43m17nnfdhg3yji5lgdra6";
  };
  releaseRev = v: "refs/tags/v${v}";

  propagatedBuildInputs = [
    coqhammer-tactics
  ];

  mlPlugin = true;

  makeFlags = [ "BINDIR=$(out)/bin/" ];
  buildPhase = "make plugin";
  installTargets = "install-plugin";

  meta = with lib; {
    homepage = "http://cl-informatik.uibk.ac.at/cek/coqhammer/";
    description = "Automation for Dependent Type Theory";
    license = licenses.lgpl21;
  };
}
