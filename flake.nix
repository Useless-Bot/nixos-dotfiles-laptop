{
  description = "Flake setup";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyroclear.url = "github:shreyanth-sureshkrishnaa/pyroclear";

    ly-balatro.url = "github:sophronesis/nix-ly-balatro-theme";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      pyroclear,
      home-manager,
      ly-balatro,
      noctalia,
      ...
    }:
    {
      nixosConfigurations.aldia = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
          inherit ly-balatro;
        };

        modules = [
          ./configuration.nix

          noctalia.nixosModules.default

          ly-balatro.nixosModules.default

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.hayden = import ./home.nix;
              backupFileExtension = "backup";
            };
          }

          {
            environment.systemPackages = [
              pyroclear.packages.${system}.default
            ];
          }
        ];
      };
    };
}
