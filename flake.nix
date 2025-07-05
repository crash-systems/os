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
        env.CC = "i686-elf-gcc";

        inputsFrom = [ self.packages.${pkgs.system}.os ];
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: let
      pkgs' = self.packages.${pkgs.system};
    in {
      binutils-686 = pkgs.callPackage ./nix/binutils-2-36.nix pkgs';

      gcc-686 = pkgs.callPackage ./nix/gcc-10-2-0.nix pkgs';

      os = pkgs.callPackage ./nix/os.nix {
         inherit (pkgs') gcc-686 binutils-686;
      };

      default = (pkgs.writeShellScriptBin "run" ''
        qemu-system-i386 -cdrom ${pkgs'.os}/iso/os.iso
      '');
    });
  };
}
