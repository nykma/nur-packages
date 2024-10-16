{
  lib, fetchFromGitHub, makeRustPlatform, rust-bin,
  llvmPackages, pkg-config,
  libgcc,
}:
let
  pname = "reth";
  version = "1.1.0";
  hash = "sha256-VwBVfEJUU9ttxfKBHxCcIZjbdlLKe4fGOBUo0w9dsso=";
  cargoHash = "sha256-lf6B1UZALnf/XExAWUYTm7RHjXXaLCYEHxq00/1nFCQ=";
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };

in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash;

  src = fetchFromGitHub {
    inherit hash;
    owner = "paradigmxyz";
    repo = pname;
    rev = "v${version}";
  };

  nativeBuildInputs = [ llvmPackages.clang pkg-config ];
  buildInputs = [ libgcc ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # skip testing
  doCheck = false;

  meta = with lib; {
    description = "Modular, contributor-friendly and blazing-fast implementation of the Ethereum protocol, in Rust";
    homepage = "https://reth.rs";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64_linux" "x86_64-darwin" "aarch64_darwin" ];
  };
}
