{
  description = "Typst development environment";

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
        pkgs = import nixpkgs {
          inherit system;
        };

        # TinyMist binary from GitHub releases (patched for NixOS)
        tinymist = let
          version = "0.14.4";
          src = pkgs.fetchurl {
            url = "https://github.com/Myriad-Dreamin/tinymist/releases/download/v${version}/tinymist-linux-x64";
            hash = "sha256-gmVlMmWrNWcK/hp+9gxl49/7Dd3nXu9ryndDSKyCYw4=";
          };
        in
          pkgs.stdenv.mkDerivation {
            pname = "tinymist";
            inherit version src;

            nativeBuildInputs = with pkgs; [
              autoPatchelfHook
            ];

            buildInputs = with pkgs; [
              stdenv.cc.cc.lib
              glibc
            ];

            dontUnpack = true;

            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/tinymist
              chmod +x $out/bin/tinymist
            '';
          };
        # Base shell configuration shared by all variants
        baseShell = {
          buildInputs = with pkgs; [
            typst
            besley
            fontconfig
            tinymist
          ];

          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = [pkgs.besley];
          };
        };
      in {
        # Default: Automatically opens Cursor with typst profile in current directory
        devShells.default = pkgs.mkShell (baseShell
          // {
            shellHook = ''exec cursor --profile "typst" .'';
          });

        # Simple: Just sets up the environment without opening Cursor
        devShells.simple = pkgs.mkShell (baseShell
          // {
            shellHook = ''
              echo "Typst development environment ready!"
            '';
          });

        # Manual: Shows instructions for opening Cursor manually
        devShells.manual = pkgs.mkShell (baseShell
          // {
            shellHook = ''
              echo "Typst development environment ready!"
              echo "Run 'cursor --profile typst .' to open Cursor in this directory."
            '';
          });
      }
    );
}
