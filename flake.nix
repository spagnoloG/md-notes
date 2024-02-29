{
  description = "md-notes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ];
        };
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [ mkdocs ]);
      in {
        devShells.default = pkgs.mkShell { buildInputs = [ pythonEnv ]; };
      });
}

