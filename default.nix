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
    cvc4-fake             = callPackage ./packages/cvc4-fake.nix {};
    isabelle-hacked       = nixpkgs.isabelle.overrideAttrs {
      # fixes errors like
      # > ERROR: noBrokenSymlinks: the symlink /nix/store/9gpfa0w826nwcgjg1jwh5fbgahvai76h-isabelle-2024/Isabelle2024/contrib/e-3.0.03-1/src/lib/PCL2.a points to a missing target /nix/store/9gpfa0w826nwcgjg1jwh5fbgahvai76h-isabelle-2024/Isabelle2024/contrib/e-3.0.03-1/src/PCL2/PCL2.a
      postPatch = ''
        find contrib/e-3.0.03-1 -iname '*.a' -print -delete
      '';
    };
    apalache              = callPackage ./packages/apalache.nix { jdk = nixpkgs.jdk17_headless; scala = nixpkgs.scala_2_12; };
    nbdkit                = callPackage ./packages/nbdkit.nix {};
    ls4                   = callPackage ./packages/ls4.nix {};
    zenon                 = callPackage ./packages/zenon.nix {};
    tlaps                 = callPackage ./packages/tlaps.nix { cvc4 = self.cvc4-fake; isabelle = self.isabelle-hacked; };
    tlatools-complete     = callPackage ./packages/tlatools-complete.nix { jre = nixjars.jre; };
    crosstool-ng          = callPackage ./packages/crosstool-ng.nix {};
    coqhammer-tactics     = callPackage ./packages/coqhammer-tactics.nix {};
    coqhammer             = callPackage ./packages/coqhammer.nix {};
    zipperposition        = callPackage ./packages/zipperposition.nix { ocamlPackages = nixpkgs.ocaml-ng.ocamlPackages_4_10; };
  };

in self
