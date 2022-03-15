{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    crate2nix.url = "github:kolloch/crate2nix";
    crate2nix.flake = false;

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, crate2nix, ... }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              rust-overlay.overlay
              (self: super: {
                # Because rust-overlay bundles multiple rust packages into one
                # derivation, specify that mega-bundle here, so that crate2nix
                # will use them automatically.
                rustc = self.rust-bin.stable.latest.default;
                cargo = self.rust-bin.stable.latest.default;
              })
            ];
          };

          inherit (import "${crate2nix}/tools.nix" { inherit pkgs; })
            generatedCargoNix;
        in
        rec {
          devShell = pkgs.mkShell { buildInputs = with pkgs; [ rustc ]; };

          apps = {
            wallabag-saver = {
              type = "app";
              program = "${self.packages."${system}".wallabag-saver}/bin/wallabag-saver";
            };
          };

          defaultApp = apps.wallabag-saver;

          packages = {
            wallabag-saver =
              let
                name = "wallabag-saver";
                project =
                  pkgs.callPackage
                    (generatedCargoNix {
                      inherit name;
                      src = ./.;
                    })
                    {
                      inherit pkgs;
                    };
              in
              project.rootCrate.build;
          };

          defaultPackage = packages.wallabag-saver;
        });
}
