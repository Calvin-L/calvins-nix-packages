{
  fetchFromGitHub,
  lib,
  libiconv,
  makeRustPlatform,
  makeWrapper,
  rust-toolchain,
  rsync,
  stdenv,
  z3,
  zlib,
}:

let
  toolchain = rust-toolchain;
  verusRustPlatform = makeRustPlatform {
    cargo = toolchain;
    rustc = toolchain;
  };
in
verusRustPlatform.buildRustPackage (finalAttrs: {
  pname = "verus";
  version = "0.2026.10.04.426d8b0";
  src = fetchFromGitHub {
    owner = "verus-lang";
    repo = "verus";
    rev = "release/${finalAttrs.version}";
    hash = "sha256-g+BhLXECLMUQ/b1Fm8Ef7qyzIeaglmQtrtszvTloOhs=";
  };
  cargoHash = "sha256-MiNxV1m8WFwOflT/befOR1hynCvxYLp6+lQk1yMSrSo=";
  sourceRoot = "${finalAttrs.src.name}/source";
  nativeBuildInputs = [
    makeWrapper
    rsync
  ];
  buildInputs = [
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  VARGO_TOOLCHAIN = "${toolchain.version}-${stdenv.hostPlatform.rust.rustcTarget}";
  VERUS_USE_RUSTUP = "0";
  VERUS_Z3_PATH = lib.getExe z3;
  RUST_BACKTRACE = "1";

  # Nix's target rustflags override the upstream [build] rustflags.
  RUSTFLAGS = [
    "--cfg=verus_keep_ghost"
  ];

  postPatch = ''
    substituteInPlace rust_verify/build.rs \
      --replace-fail \
        'use cargo_verus_toolchains::versions::{get_git_head_paths, get_verus_version};' \
        "" \
      --replace-fail \
        'get_verus_version(true).expect("version info")' \
        '("${finalAttrs.version}".to_owned(), "${finalAttrs.version}".to_owned())' \
      --replace-fail \
        'get_git_head_paths().expect("Git HEAD paths")' \
        'Vec::<std::path::PathBuf>::new()'

    # The launcher also discovers its toolchain through rustup by default.
    cat > verus/build.rs <<'EOF'
    fn main() {
        let toolchain = std::env::var("VARGO_TOOLCHAIN").expect("Nix toolchain");
        println!("cargo:rerun-if-env-changed=VARGO_TOOLCHAIN");
        println!("cargo:rustc-env=VERUS_TOOLCHAIN={toolchain}");
    }
    EOF

    # This package uses the supplied Nix solver, including its version check.
    substituteInPlace cargo-verus-toolchains/src/external_deps.rs \
      --replace-fail 'pub const Z3_VERSION: &str = "4.16.0";' \
        'pub const Z3_VERSION: &str = "${z3.version}";'
  '';

  # Assemble the same artifacts as vargo, without rustup or network access.
  buildPhase = ''
    runHook preBuild
    cargo build --offline --locked --release -j "$NIX_BUILD_CORES" \
      -p rust_verify -p verus_builtin -p verus_builtin_macros \
      -p verus_state_machines_macros -p vstd_build -p verus -p cargo-verus
    cargo run --offline --locked --release -p vstd_build -- "$PWD/target-verus/release" \
      --release
    runHook postBuild
  '';

  # Upstream tests require the vargo test harness.
  doCheck = false;

  # Stripping Rust libraries removes metadata needed by the tooling.
  stripExclude = [ "libexec/verus/lib*" ];

  # Ugly (but functional!) install script based on Verus's release tooling.
  installPhase = ''
    runHook preInstall
    mkdir -p "$out/libexec/verus" "$out/bin"
    for file in verus cargo-verus rust_verify libverus_builtin.rlib \
      libverus_builtin_macros${stdenv.hostPlatform.extensions.sharedLibrary} \
      libverus_state_machines_macros${stdenv.hostPlatform.extensions.sharedLibrary} \
      libvstd.rlib vstd.vir; do
      cp "target-verus/release/$file" "$out/libexec/verus/"
    done
    for dir in builtin builtin_macros state_machines_macros vstd; do
      rsync -a --exclude target "$dir" "$out/libexec/verus/"
    done
    touch "$out/libexec/verus/verus-root"
    echo '${finalAttrs.version}' > "$out/libexec/verus/version.txt"
    for exe in verus cargo-verus; do
      makeWrapper "$out/libexec/verus/$exe" "$out/bin/$exe" \
        --set VERUS_USE_RUSTUP 0 \
        --set-default VERUS_Z3_PATH ${lib.getExe z3} \
        --prefix PATH : ${lib.makeBinPath [ toolchain ]} \
        --suffix ${if stdenv.hostPlatform.isDarwin then "DYLD_FALLBACK_LIBRARY_PATH" else "LD_LIBRARY_PATH"} : ${toolchain}/lib
    done
    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/verus" --version
    cat > smoke.rs <<'EOF'
    use vstd::prelude::*;
    verus! {
        proof fn arithmetic() { assert(1 + 1 == 2); }
    }
    fn main() {}
    EOF
    "$out/bin/verus" smoke.rs
    runHook postInstallCheck
  '';
})
