{ nixpkgs ? import <nixpkgs> {},
  nixjars ? import <nixjars> { nixpkgs=nixpkgs; } }:

let

  callPackage = nixpkgs.lib.callPackageWith (nixjars // nixpkgs // self);

  self = {
    # my projects
    ezpsl                 = callPackage ./packages/ezpsl.nix {};
    retry-forever         = callPackage ./packages/retry-forever.nix {};
    many-smt              = callPackage ./packages/many-smt.nix {};
    caltac                = callPackage ./packages/caltac.nix {};
    crash-safe-io         = callPackage ./packages/crash-safe-io.nix {};

    # other open-source
    isabelle_2011         = callPackage ./packages/isabelle_2011.nix {};
    isabelle_2011_pure    = callPackage ./packages/isabelle_2011_logic.nix { logic_name = "Pure"; };
    # isabelle_2011_hol     = callPackage ./packages/isabelle_2011_logic.nix { logic_name = "HOL"; extra_inputs = [self.isabelle_2011_pure] }; # broken, tries to build pure again >:(
    apalache              = callPackage ./packages/apalache.nix { jdk = nixpkgs.jdk17_headless; scala = nixpkgs.scala_2_12; };
    nbdkit                = callPackage ./packages/nbdkit.nix {};
    ls4                   = callPackage ./packages/ls4.nix {};
    ptl-to-trp-translator = callPackage ./packages/ptl-to-trp-translator.nix {};
    zenon                 = callPackage ./packages/zenon.nix {};
    tlaps                 = callPackage ./packages/tlaps.nix {};
    tlatools-complete     = callPackage ./packages/tlatools-complete.nix { jre = nixjars.jre; };
    crosstool-ng          = callPackage ./packages/crosstool-ng.nix {};
    coqhammer-tactics     = callPackage ./packages/coqhammer-tactics.nix {};
    coqhammer             = callPackage ./packages/coqhammer.nix {};
    zipperposition        = callPackage ./packages/zipperposition.nix { ocamlPackages = nixpkgs.ocaml-ng.ocamlPackages_4_10; };
  };

in self
