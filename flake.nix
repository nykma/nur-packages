{
  description = "Nyk Ma's personal NUR repository";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, rust-overlay }:
    let
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      });
    in
    {
      legacyPackages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        import ./default.nix {
          inherit pkgs;
        });
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        pkgs.lib.filterAttrs (_: v: pkgs.lib.isDerivation v) self.legacyPackages.${system});
    };
}
