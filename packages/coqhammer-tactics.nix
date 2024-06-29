{ coqPackages, version ? null }:

let lib = coqPackages.lib; in
let coq = coqPackages.coq; in

coqPackages.mkCoqDerivation {
  inherit version;
  pname = "coqhammer-tactics";
  owner = "lukaszcz";
  repo = "coqhammer";
  defaultVersion = with lib.versions; lib.switch coq.coq-version [
    { case = "8.18"; out = "v1.3.2-coq8.18"; }
    { case = "8.19"; out = "v1.3.2-coq8.19"; }
  ] null;
  release = {
    "1.3.2-coq8.18".sha256 = "4c619b72bed0963436eca485bfceda8448790e8cd128292385a970190c0eed6a";
    "1.3.2-coq8.19".sha256 = "ecc176131220dad97878280cafde346caad30d8fb558b82e2ea89f13cc827e01";
  };
  releaseRev = v: "refs/tags/v${v}";

  mlPlugin = true;

  buildPhase = "make tactics";
  installTargets = "install-tactics";

  meta = with lib; {
    homepage = "http://cl-informatik.uibk.ac.at/cek/coqhammer/";
    description = "Automation for Dependent Type Theory";
    license = licenses.lgpl21;
  };
}
