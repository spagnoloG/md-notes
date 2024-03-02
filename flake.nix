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
            trove_classifiers = python-super.trove_classifiers.overrideAttrs
              (oldAttrs: {
                version = "2023.10.18";
                src = python-super.fetchPypi {
                  pname = "sha256-";
                  version = "2023.10.18";
                  sha256 = "sha256-8385160a12aac69c93fff058fb613472ed773a24a27eb3cd4b144cfbdd79f38c";
                };
              });
            mkdocs_material = python-super.buildPythonPackage rec {
              pname = "mkdocs_material";
              version = "9.5.12";
              src = python-super.fetchPypi {
                inherit pname version;
                sha256 = "sha256-X2nO9qiqpAULgS9ysQlP2j0Hm5pRzyeiRyRMA+xFXpc=";
              };

              nativeBuildInputs = with python-super; [
                pip
                setuptools
                wheel
                hatchling
                hatch-nodejs-version
                hatch-requirements-txt
              ];

              propagatedBuildInputs = with python-super; [
                setuptools
                pyyaml
                trove_classifiers
              ];

              format = "pyproject";
            };
          };
        };

        pythonEnv =
          python3.withPackages (ps: with ps; [ mkdocs mkdocs-material ]);
      in {
        devShells.default = pkgs.mkShell { buildInputs = [ pythonEnv ]; };
      });
}

