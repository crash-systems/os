{
  stdenvNoCC,
  i386-elf-gcc,
  i386-elf-tcc,
  i386-elf-binutils,
  grub2,
  libisoburn,
  withGCC ? true
}:

let
  cc = if withGCC then i386-elf-gcc else i386-elf-tcc;
in
stdenvNoCC.mkDerivation {
 pname = "os";
 version = "0.0.1";

 src = ./..;

 env.CC = cc.meta.mainProgram;

 nativeBuildInputs = [
   cc
   i386-elf-binutils
   grub2
   libisoburn
 ];

 installPhase = ''
   runHook preInstall

   install -Dm577 os.iso $out/iso/os.iso

   runHook postInstall
'';
}
