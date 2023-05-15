{
  description = "Environment for infic engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
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
      devShell =
        pkgs.mkShell
        {
          packages = with pkgs; [
            zig
            # (zig.overrideAttrs (_: rec {
            # version = "";
            #   src = pkgs.fetchFromGitHub {
            #     owner = "ziglang";
            #     repo = "zig";
            #     rev = version;
            #     hash = "sha256-69QIkkKzApOGfrBdgtmxFMDytRkSh+0YiaJQPbXsBeo=";
            #   };
            # }))
          ];
        };
    });
}
