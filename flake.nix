{
  description = "Environment for infic engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    self,
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
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = {
        zig = pkgs.callPackage ./nix/zig.nix {
          llvmPackages = pkgs.llvmPackages_16;
        };
      };
      devShell =
        pkgs.mkShell
        {
          packages = with pkgs;
            [
              self.packages.${system}.zig
              python3Minimal
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
