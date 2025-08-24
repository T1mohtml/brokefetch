{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux.brokefetch = pkgs.stdenv.mkDerivation {
        pname = "brokefetch";
        version = "latest-stable";

        src = ./.;

        buildInputs = [
          pkgs.bash
        ];

        installPhase = ''
          mkdir -p $out/bin
          cp ./brokefetch.sh $out/bin/brokefetch
          chmod +x $out/bin/brokefetch
        '';
      };

      packages.x86_64-linux.brokefetch-beta = pkgs.stdenv.mkDerivation {
        pname = "brokefetch";
        version = "beta";

        src = ./.;

        buildInputs = [
          pkgs.bash
        ];

        installPhase = ''
          mkdir -p $out/bin
          cp ./brokefetch_beta.sh $out/bin/brokefetch
          chmod +x $out/bin/brokefetch
        '';
      };

      defaultPackage.x86_64-linux = self.packages.x86_64-linux.brokefetch;
    };
}
