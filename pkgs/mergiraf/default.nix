{
  lib, makeRustPlatform, rust-bin,
  git,
  ...
}:
let
  pname = "mergiraf";
  version = "0.3.1";
  src = builtins.fetchGit {
    url = "https://codeberg.org/mergiraf/mergiraf.git";
    ref = "v${version}";
    allRefs = true;
    rev = "6e40800d33640217d83177e7dfaf4a90a739d81e";
  };

  rustPlatform = makeRustPlatform {
    cargo = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
    rustc = rust-bin.selectLatestNightlyWith (toolchain: toolchain.default);
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;
  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    # outputHashes = {
    # };
  };
  nativeBuildInputs = [ git ];
  meta = with lib; {
    description = "A syntax-aware git merge driver for a growing collection of programming languages and file formats.";
    homepage = "https://mergiraf.org";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
