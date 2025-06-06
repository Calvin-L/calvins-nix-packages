# Calvin's Nix Channel

This is a Nix "channel" with packages you can build.

To list available packages:

    nix-env --description -qaPf . | sort

To build one, e.g. `tlaps`:

    nix-build . -A tlaps -o result
    ./result/bin/tlapm --config

For a slightly more stable experience, replace `.` with `./stable.nix` in the
commands above.  `stable.nix` pins exact upstream dependencies for a
reproducible experience.

## What's Here?

A few of my own projects:

 - [`caltac`](https://github.com/Calvin-L/caltac), an opinionated set of Coq
   tactics.
 - [`crash-safe-io`](https://github.com/Calvin-L/crash-safe-io/), a simple and
   high-quality library implementing crash-safe file operations in Java.
 - [`ezpsl`](https://github.com/Calvin-L/ezpsl/), a language for modeling
   concurrent programs.
 - [`many-smt`](https://github.com/Calvin-L/many-smt/), an SMT-LIB portfolio
   solver.
 - [`retry-forever`](https://github.com/Calvin-L/retry-forever), for when
   failure isn't an option.

And a few open source things I use:

 - [`tlaps`](https://tla.msr-inria.inria.fr/tlaps/content/Home.html), the TLA+
   proof system.  This is a newer and far more functional version than the one
   that ships with Nixpkgs.  It includes:
   - [`isabelle-2024`](https://isabelle.in.tum.de/), a slightly older version
     of Isabelle used by `tlaps`
   - [`ls4`](https://github.com/quickbeam123/ls4), which is used by `tlaps`.
   - [`zenon`](https://github.com/zenon-prover/zenon), a first-order logic
     solver.
   - [`zipperposition`](https://github.com/sneeuwballen/zipperposition/), a
     first-order logic solver.
 - `tlatools-complete`, a wrapper for the TLA+ tools that includes the
   community modules and TLAPS standard library.
 - [`apalache`](https://github.com/informalsystems/apalache), a symbolic TLA+
   checker.  (TODO: my version is very old. Can I use the Nix flake in the
   Apalache repo?)
 - [`nbdkit`](https://gitlab.com/nbdkit/nbdkit), for userspace block devices on
   Linux.
 - [`crosstool-ng`](https://crosstool-ng.github.io/), which I use for
   cross-compiling to Raspberry Pi.
