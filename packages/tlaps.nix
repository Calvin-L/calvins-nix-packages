{ lib, stdenvNoCC,
  writeShellApplication,
  # core tools
  bash,
  procps,
  sysctl,
  tlapm-unwrapped,
  tlapm-isabelle-theory,
  # solvers
  z3,
  yices,
  cvc4,
  isabelle,
  zenon,
  ls4,
  zipperposition }:

let

isabelle-wrapper = writeShellApplication {
  name = "isabelle";
  runtimeInputs = [
    isabelle
    sysctl #!? WTF Isabelle...
  ];
  text = ''
    export HOME='${tlapm-isabelle-theory}/home'
    exec isabelle "$@"
  '';
};

in

writeShellApplication {
  name = "tlapm";
  runtimeInputs = [
    bash
    z3
    yices
    cvc4
    isabelle-wrapper
    zenon
    tlapm-unwrapped
    ls4
    zipperposition
    procps
  ];

  text = ''
    exec tlapm "$@"
  '';

  derivationArgs = {
    meta = tlapm-unwrapped.meta;
  };
}
