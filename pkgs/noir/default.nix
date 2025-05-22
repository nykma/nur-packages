{
  lib, fetchFromGitHub, makeRustPlatform, rust-bin,
  protobuf_29, # 29.3
}:
let
  pname = "noir";
  version = "1.0.0-beta.6";
  hash = "sha256-hy/FkQ2osn1I9oztC754W580OEgvNJ55FcnfTxd2ock=";
  cargoHash = "sha256-oD5G1UwmbW5hWnCo52VsftUSc6ww+8opinA6iw9Yagc=";
  rustPlatform = makeRustPlatform {
    cargo = rust-bin.stable.latest.default;
    rustc = rust-bin.stable.latest.default;
  };
in
rustPlatform.buildRustPackage {
  inherit pname version cargoHash;

  src = fetchFromGitHub {
    inherit hash;
    owner = "noir-lang";
    repo = pname;
    rev = "v${version}";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  PROTOC_PREBUILT_FORCE_PROTOC_PATH = "${protobuf_29}/bin/protoc";
  PROTOC_PREBUILT_FORCE_INCLUDE_PATH = "${protobuf_29}/include";
  GIT_COMMIT = version;
  GIT_DIRTY = "false";

  doCheck = false;

  meta = with lib; {
    description = "Noir is a domain specific language for zero knowledge proofs.";
    homepage = "https://noir-lang.org";
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
