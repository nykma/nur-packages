{ pkgs ? import <nixpkgs> { } }:

{
  lib = import ./lib { inherit pkgs; };
  modules = import ./modules;
  overlays = import ./overlays;

  cups-detonger = pkgs.callPackage ./pkgs/cups-detonger { };
}
