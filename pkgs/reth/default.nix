{
  lib, fetchFromGitHub, makeRustPlatform, rust-bin,
  llvmPackages, pkg-config,
  libgcc, glibc,
}:
let
  pname = "reth";
  version = "1.3.12";
  hash = "sha256-59XUrMaXMiqSELQX8i7eK4Eo8YfGjPVZHT6q+rxoSPs=";
  cargoHash = "sha256-FHQ+iPcjxwcY7uoZMXlm/lRoVA5E5wRg7qFgJe+VSEc=";
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
    platforms = [ 
      "x86_64-linux"
      # FIXME: enable until proper cargoHash for each platform is found
      # "aarch64-linux"
      # "x86_64-darwin"
      # "aarch64-darwin"
    ];
  };
}
