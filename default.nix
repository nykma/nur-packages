{
  pkgs ? import <nixpkgs> {
    overlays = [
      (import (fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz"))
    ];
  },
  pkgs-protobuf320 ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/656b40c807e4c4965198a68d1f784492397fef6c.tar.gz";
    sha256 = "sha256:0j3sxszl00kbw4i4c5dd4ip6a7f0yd3gx2y7iwqy5wkfmwp4k1fl";
  }) { },
}:

rec {
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  cups-detonger = pkgs.callPackage ./pkgs/cups-detonger { };
  snipaste = pkgs.callPackage ./pkgs/snipaste { };
  safeheron-crypto-suites = pkgs.callPackage ./pkgs/safeheron-crypto-suites {
    inherit (pkgs-protobuf320) protobuf3_20;
  };
  multi-party-sig = pkgs.callPackage ./pkgs/multi-party-sig {
    inherit safeheron-crypto-suites;
    inherit (pkgs-protobuf320) protobuf3_20;
  };
  cryptopp-cmake = pkgs.callPackage ./pkgs/cryptopp-cmake { };
  orca-slicer = pkgs.callPackage ./pkgs/orca-slicer { };
  snips-sh = pkgs.callPackage ./pkgs/snips.sh { };
  font-apple-color-emoji = pkgs.callPackage ./pkgs/font-apple-color-emoji { };
  onekey-wallet = pkgs.callPackage ./pkgs/onekey-wallet { };
  jwt-cpp = pkgs.callPackage ./pkgs/jwt-cpp { };
  rapidsnark = pkgs.callPackage ./pkgs/rapidsnark { };
  aws-lambda-ric-nodejs = pkgs.callPackage ./pkgs/aws-lambda-ric-nodejs { };
  v2dat = pkgs.callPackage ./pkgs/v2dat { };
  v2ray-rules-dat = pkgs.callPackage ./pkgs/v2ray-rules-dat { inherit v2dat; };
  zen-browser = pkgs.callPackage ./pkgs/zen-browser { };
  reth = pkgs.callPackage ./pkgs/reth { inherit (pkgs) rust-bin; };

  font-iosvmata = pkgs.callPackage ./pkgs/font-iosvmata { };
  font-pragmasevka = pkgs.callPackage ./pkgs/font-pragmasevka { };
  font-sarasa-term-sc-nerd = pkgs.callPackage ./pkgs/font-sarasa-term-sc-nerd { };
}
