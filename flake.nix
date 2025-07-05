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
        env.CC = pkgs.lib.getExe self.packages.${pkgs.system}.i386-elf-gcc;
        inputsFrom = [ self.packages.${pkgs.system}.os ];
      };
    });

    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: let
      pkgs' = self.packages.${pkgs.system};
    in {
      i386-elf-binutils = pkgs.callPackage ./nix/i386-elf-binutils.nix pkgs';

      i386-elf-gcc = pkgs.callPackage ./nix/i386-elf-gcc.nix pkgs';

      os = pkgs.callPackage ./nix/os.nix {
         inherit (pkgs') i386-elf-gcc i386-elf-binutils;
      };

      default = (pkgs.writeShellScriptBin "run" ''
        qemu-system-i386 -cdrom ${pkgs'.os}/iso/os.iso
      '');
    });
  };
}
