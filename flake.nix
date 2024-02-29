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

        python3 = pkgs.python3.override {
          packageOverrides = python-self: python-super: {
            mkdocs-simple-blog = python-super.buildPythonPackage rec {
              pname = "mkdocs-simple-blog";
              version = "0.0.9";
              src = python-super.fetchPypi {
                inherit pname version;
                sha256 = "sha256-DiRLvXi59w8F8YQ//aUlQKRKsb0jNh1jYilu5oc1SkU=";
              };

              nativeBuildInputs = with python-super; [
                pip
                setuptools
                wheel
                hatchling
                hatch-nodejs-version
                hatch-requirements-txt
              ];

              propagatedBuildInputs = with python-super; [ setuptools pyyaml ];

              format = "pyproject";
            };
          };
        };
        pythonEnv =
          python3.withPackages (ps: with ps; [ mkdocs mkdocs-simple-blog ]);
      in {
        devShells.default = pkgs.mkShell { buildInputs = [ pythonEnv ]; };
      });
}

