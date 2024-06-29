{ lib, stdenv, fetchurl, fetchFromGitLab,
  autoreconfHook, pkg-config, bash, gnumake, gnutls, perl }:

let
major_version = "1.35";
version = "${major_version}.2";
hash = "sha256-qizKaTUMhUXHep0RJyZZjclo4Wb9byAqcC1XgoYTxWU=";

# major_version = "1.34";
# version = "${major_version}.1";
# hash = "sha256-uUxEtd7j74Ck2aeRFFoZrHUFPaqzik2rm9OEb87xyVg=";
in

stdenv.mkDerivation {
  pname="nbdkit";
  inherit version;
  # src = fetchurl {
  #   url = "https://download.libguestfs.org/nbdkit/${major_version}-stable/nbdkit-${version}.tar.gz";
  #   # hash = "sha256-btSxeRiRSCF05SCccIT35AVJoaT213hRHJCxonn0qkg=";
  # };
  src = fetchFromGitLab {
    owner = "nbdkit";
    repo = "nbdkit";
    rev = "v${version}";
    inherit hash;
  };
  # Normally we'd split this into bin+lib+out, but bin and lib are cyclically
  # dependent on each other. :/
  outputs = ["out" "dev" "man"];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gnumake
    bash
    perl
  ];
  buildInputs = [
    gnutls.dev
  ];
  configureFlags = ["--with-manpages"];
  postPatch = ''
    patchShebangs --build .
  '';
  enableParallelBuilding = true;
  meta = {
    homepage = https://gitlab.com/nbdkit/nbdkit;
    description = "Network block device (NBD) server with stable plugin ABI and permissive license";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
