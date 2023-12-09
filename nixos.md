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

#### Python development environment:
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

#### R and C++ development environment

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


#### Rust development environment:

##### To start a rust project, firstly:

- Enter nix shell; `nix-shell -P cargo`
- Run `cargo init`
- Add dependencies to Cargo.toml
- Run `cargo check`, to generate `Cargo.lock`
- Exit nix shell, `ctrl+d`
- Run `nix develop`, and replace the cargoSha256 hash in `flake.nix` with the one generated


This [flake](https://hoverbear.org/blog/a-flake-for-your-crate/) is a modified version of the one found.

`flake.nix`

```nix
# flake.nix
{
  description = "Rust crate with Nix flake support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    naersk.url = "github:nmattia/naersk";
    flake-utils.url = "github:numtide/flake-utils";
    naersk.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, naersk, flake-utils, ... }: 
    let
      cargoToml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in
    {
      overlay = final: prev: {
        "${cargoToml.package.name}" = final.callPackage ./. { inherit naersk; };
      };

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        {
          "${cargoToml.package.name}" = pkgs."${cargoToml.package.name}";
        });

      defaultPackage = forAllSystems (system: (import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      })."${cargoToml.package.name}");

      checks = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        {
          format = pkgs.runCommand "check-format" {
            buildInputs = with pkgs; [ rustfmt cargo ];
          } ''
            ${pkgs.rustfmt}/bin/cargo-fmt fmt --manifest-path ${./.}/Cargo.toml -- --check
            touch $out # it worked!
          '';
          "${cargoToml.package.name}" = pkgs."${cargoToml.package.name}";
        });

      devShell = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ self.overlay ];
          };
        in
        pkgs.mkShell {
          inputsFrom = with pkgs; [
            pkgs."${cargoToml.package.name}"
          ];
          buildInputs = with pkgs; [
            rustfmt
            nixpkgs-fmt
            fontconfig
          ];
          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
        });
    };
}
```

`default.nix`

```nix
# default.nix
{ lib
, naersk
, stdenv
, clangStdenv
, hostPlatform
, targetPlatform
, pkg-config
, libiconv
, rustfmt
, cargo
, rustc
  # , llvmPackages # Optional
  # , protobuf     # Optional
}:

let
  cargoToml = (builtins.fromTOML (builtins.readFile ./Cargo.toml));
in

naersk.lib."${targetPlatform.system}".buildPackage rec {
  src = ./.;

  buildInputs = [
    rustfmt
    pkg-config
    cargo
    rustc
    libiconv
  ];
  checkInputs = [ cargo rustc ];

  doCheck = true;
  CARGO_BUILD_INCREMENTAL = "false";
  RUST_BACKTRACE = "full";
  copyLibs = true;

  # Optional things you might need:
  #
  # If you depend on `libclang`:
  # LIBCLANG_PATH = "${llvmPackages.libclang}/lib";
  #
  # If you depend on protobuf:
  # PROTOC = "${protobuf}/bin/protoc";
  # PROTOC_INCLUDE = "${protobuf}/include";

  name = cargoToml.package.name;
  version = cargoToml.package.version;

  meta = with lib; {
    description = cargoToml.package.description;
    homepage = cargoToml.package.homepage;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
```

#### C development environment with custom library

`download_library.sh`

```bash
#!/bin/bash

set -eux

WFDB_LIB_URL="https://archive.physionet.org/physiotools/wfdb/lib"

mkdir -p wfdb
cd wfdb

# List of files to download
files=(
  "COPYING.LIB"
  "Makefile"
  "Makefile.top"
  "Makefile.tpl"
  "annot.c"
  "calib.c"
  "ecgcodes.h"
  "ecgmap.h"
  "signal.c"
  "wfdb.h"
  "wfdb.h0"
  "wfdbinit.c"
  "wfdbio.c"
  "wfdblib.h"
  "wfdblib.h0"
)

for file in "${files[@]}"; do
    echo "Downloading $file..."
    curl -O "$WFDB_LIB_URL/$file"
done

echo "All files downloaded."
```


```nix
{
  description = "A Nix flake for C project with WFDB library";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
      name = "obss-assignment-1";

      src = self;

      buildInputs = [
        nixpkgs.legacyPackages.x86_64-linux.gcc
        nixpkgs.legacyPackages.x86_64-linux.gnumake
        nixpkgs.legacyPackages.x86_64-linux.curl
      ];

      unpackPhase = "true";

      buildPhase = ''
        # Copy the wfdb directory to the build directory
        cp -r ${self}/a1/wfdb .

        cd wfdb
        chmod -R u+w .

        # Build the WFDB library
        make -f Makefile

        # Create a symlink for the linker to find the library
        ln -s libwfdb.so.10.6 libwfdb.so

        cd ..

        # Building your program with the correct include path
        gcc -Iwfdb -o qrs_detect ${self}/a1/example.c -lm -L./wfdb -lwfdb
      '';

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib

        # Copy the binary
        cp qrs_detect $out/bin/

        # Copy the library files to the output directory
        cp wfdb/libwfdb.so.10.6 $out/lib/
        ln -s $out/lib/libwfdb.so.10.6 $out/lib/libwfdb.so
        ln -s $out/lib/libwfdb.so.10.6 $out/lib/libwfdb.so.10
      '';
    };
  };
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
