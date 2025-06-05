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
    polyml-for-isabelle   = nixpkgs.polyml.overrideAttrs {
      pname = "polyml-for-isabelle";
      configureFlags = [
        "--with-system-libffi"
        "--enable-intinf-as-int"
        "--with-gmp"
        "--disable-shared"
      ];
      buildFlags = [ "compiler" ];
    };
    isabelle-2024         = callPackage ./packages/isabelle-2024.nix { polyml = self.polyml-for-isabelle; };
    apalache              = callPackage ./packages/apalache.nix { jdk = nixpkgs.jdk17_headless; scala = nixpkgs.scala_2_12; };
    nbdkit                = callPackage ./packages/nbdkit.nix {};
    ls4                   = callPackage ./packages/ls4.nix {};
    zenon                 = callPackage ./packages/zenon.nix {};
    tlaps                 = callPackage ./packages/tlaps.nix { cvc4 = self.cvc4-fake; isabelle = self.isabelle-2024; };
    tlatools-complete     = callPackage ./packages/tlatools-complete.nix { jre = nixjars.jre; };
    crosstool-ng          = callPackage ./packages/crosstool-ng.nix {};
    coqhammer-tactics     = callPackage ./packages/coqhammer-tactics.nix {};
    coqhammer             = callPackage ./packages/coqhammer.nix {};
    zipperposition        = callPackage ./packages/zipperposition.nix { ocamlPackages = nixpkgs.ocaml-ng.ocamlPackages_4_10; };
  };

in self
