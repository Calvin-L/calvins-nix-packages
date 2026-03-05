import ./default.nix rec {

  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/457378d5f35a52ad2cbae0950cef32b7d521e264.tar.gz";
    sha256 = "0q9rhbccbnbanzfdcvzw5fpglk2x6n019ky7sc7wlz87n714i72b";
  }) {};

  nixjars = import (builtins.fetchTarball {
    url = "https://github.com/Calvin-L/nixjars/archive/2a6264b63243b7f1ee9f1031278aa8f1b303b0b5.tar.gz";
    sha256 = "1nd58s1q5qn8zkw7bkrvchgc28p8arl5mqavs2bx7l27b16a6crn";
  }) {nixpkgs=nixpkgs;};

}
