{
  description = "Nix Fundamentals Course";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.nix-foundations = pkgs.callPackage ./nix/default.nix {inherit pkgs system;};
        devShells.default = import ./nix/shell.nix {inherit pkgs system;};
        formatter = pkgs.alejandra;
      }
    );
}
