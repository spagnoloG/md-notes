# Nixos

### Managing system generations 

###### List system generations 

```
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

###### Delete old generations

```bash
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
```
###### Collect garbage

```bash
sudo nix-collect-garbage -d
```

######  Hard link identical files (remove duplicate libraries)

```bash
sudo nix-store --optimize
```

file: clean-nix.sh
```bash
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage -d
sudo nix-store --optimize
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Home manager
manage user configuration files using nix

Install it [here](https://nix-community.github.io/home-manager/index.html#sec-install-nixos-module).



### Flakes

Flakes are cool to have nice reproducible environments.
Example python flake environment:


```nix
{
  description = "Python development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };
        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          matplotlib
          opencv4
          pip
          pillow
          tqdm
        ]);
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv
          ];
        };
      }
    );
}

```


Example R and C++ development environment:
You should really swithc to flakes if you are using nixos ;) .

```nix
{
  description = "R and C++: DataScience environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
        
        my-R-packages = with pkgs.rPackages; [
          ggplot2
          dplyr
          xts
          gridExtra
          shiny
          shinydashboard
          tidyr
          tidyverse
          viridis
          arrow
          data_table
          tinytex
          reshape2
        ];

        my-cpp-packages = with pkgs; [
          arrow-cpp
          clang
          gcc
          cmake
          pkg-config
        ];

        RStudio-with-my-packages = pkgs.rstudioWrapper.override {
          packages = my-R-packages;
        };

        R-with-my-packages = pkgs.rWrapper.override {
          packages = my-R-packages;
        };

        latex-pkgs = with pkgs; [
            texlive.combined.scheme-basic
        ];
        
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            R-with-my-packages
            RStudio-with-my-packages
            my-cpp-packages
            latex-pkgs
          ];
        };
      }
    );
}
```

To enter development environmnent issue:

```bash
nix develop
```

if you add any new dependency to the list issue:

```bash
nix flake lock --update-input nixpkgs
nix develop --refresh
```
