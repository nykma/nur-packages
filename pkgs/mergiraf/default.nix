{
  lib, makeRustPlatform, rust-bin,
  git,
  ...
}:
let
  pname = "mergiraf";
  version = "0.2.0";
  src = builtins.fetchGit {
    url = "https://codeberg.org/mergiraf/mergiraf.git";
    ref = "v${version}";
    allRefs = true;
    rev = "5e0e340b1f666c36720531e0a7ac7b5417c96031";
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
    outputHashes = {
      "tree-sitter-go-0.23.1" = "sha256-elPqkvVYs0vADOuN/umDteWP5hqcXhQAoSkqYDtTxaU=";
      "tree-sitter-xml-0.7.0" = "sha256-RTWvOUAs3Uql9DKsP1jf9FZZHaZORE40GXd+6g6RQZw=";
      "tree-sitter-yaml-0.6.1" = "sha256-gS+SjOnGl/86U9VV/y1ca7naYIe7DAOvOv++jCRLTKo=";
    };
  };
  nativeBuildInputs = [ git ];
  meta = with lib; {
    description = "A syntax-aware git merge driver for a growing collection of programming languages and file formats.";
    homepage = "https://mergiraf.org";
    license = licenses.gpl3;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
  };
}
