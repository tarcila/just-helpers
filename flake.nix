{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: {
    devShells.default = let
      inherit system;
      pkgs = import nixpkgs {
        inherit system;
      };
    in pkgs.mkShellNoCC {
      packages = with pkgs; [ jq just ];
      
    };
  });
}
