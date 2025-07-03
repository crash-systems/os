{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ] (system: function nixpkgs.legacyPackages.${system});
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShellNoCC {
        packages =
          (builtins.attrValues self.packages.${pkgs.system})
          ++ (with pkgs; [
            qemu
            grub2
            libisoburn
        ]);
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: let
      pkgs' = self.packages.${pkgs.system};
    in {
      binutils = pkgs.callPackage ./nix/binutils-2-36.nix pkgs';

      # gcc invoke ar through the environment (AR), but has as hardcorded
      as = pkgs.callPackage ./nix/as.nix pkgs';

      gcc = pkgs.callPackage ./nix/gcc-10-2-0.nix pkgs';
    });
  };
}
