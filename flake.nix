{
  description = "Environment for infic engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    zig-overlay.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    zig-overlay,
    ...
  }: let
    supportedSystems = let
      inherit (flake-utils.lib) system;
    in [
      system.aarch64-linux
      system.x86_64-linux
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_: super: {
            glibc = super.glibc.overrideAttrs (_: let
              version = "2.36";
              patchSuffix = "-8";
              sha256 = "";
            in {
              version = version + patchSuffix;
              src = super.fetchurl {
                url = "mirror://gnu/glibc/glibc-${version}.tar.xz";
                inherit sha256;
              };
            });
          })
        ];
      };
    in {
      devShell =
        pkgs.mkShell
        {
          packages = with pkgs;
            [
              zig-overlay.packages.${system}.master
              libGL
              glfw
            ]
            ++ (with pkgs.xorg; [
              libX11
              libXrandr
              libXinerama
              libXcursor
              libXi
            ]);
        };
    });
}
