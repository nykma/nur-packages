{
  lib, fetchFromGitHub, makeRustPlatform, rust-bin,
  llvmPackages, pkg-config,
  libgcc, glibc,
}:
let
  pname = "reth";
  version = "1.1.5";
  hash = "sha256-bQ45SJCdIEtBqhh/2bQh0CS8KC9eI4zF38LSL/LDOSk=";
  cargoHash = "sha256-VEwDru2n1iY3DKN8GhPtzUAeKDkH5IpkqdrQy/2aitw=";
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
  buildInputs = [ libgcc glibc ];

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  # skip testing
  doCheck = false;

  meta = with lib; {
    description = "Modular, contributor-friendly and blazing-fast implementation of the Ethereum protocol, in Rust";
    homepage = "https://reth.rs";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
