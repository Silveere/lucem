{
  description = "An open-source bootstrapper for Sober, similar to Bloxstrap.";

  inputs = {
    systems.url = "github:nix-systems/default";
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";
  };

  outputs = {
    nixpkgs,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
        inputs,
        self,
        config,
        lib,
        ...
      } @ args: {
        systems = import inputs.systems;
        imports = [
          inputs.devshell.flakeModule
        ];

        perSystem = {
          config,
          inputs',
          self',
          pkgs,
          ...
        }: {
          packages = {
            default = config.packages.lucem;
            lucem = pkgs.callPackage ./package.nix { };
          };

        };
      }
    );
}
