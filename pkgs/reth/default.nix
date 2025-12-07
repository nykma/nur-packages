{
  lib, fetchFromGitHub, makeRustPlatform, rust-bin,
  llvmPackages, pkg-config,
  libgcc, glibc,
}:
let
  pname = "reth";
  version = "1.6.0";
  hash = "sha256-dT5H+0lfkf9QeWAV7BsCpctzNCwF3oW9Gn7CM7hexDs=";
  cargoHash = "sha256-jWSeTGtq3K7vuhOhOa3BiNJ3lnhNNG8LYWr/xFFljAM=";
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
  src = fetchFromGitHub {
    inherit hash;
    owner = "paradigmxyz";
    repo = pname;
    rev = "v${version}";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash src;

  nativeBuildInputs = [ llvmPackages.clang pkg-config ];
  buildInputs = [ libgcc glibc ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # skip testing
  doCheck = false;

  meta = with lib; {
    description = "Modular, contributor-friendly and blazing-fast implementation of the Ethereum protocol, in Rust";
    homepage = "https://reth.rs";
    license = licenses.asl20;
    platforms = [ 
      "x86_64-linux"
      # FIXME: enable until proper cargoHash for each platform is found
      # "aarch64-linux"
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];
  };
}
