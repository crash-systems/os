{
  stdenvNoCC,
  i386-elf-gcc,
  i386-elf-binutils,
  grub2,
  libisoburn,
}:
stdenvNoCC.mkDerivation {
 pname = "os";
 version = "0.0.1";

 src = ./..;

 env.CC = "i386-elf-gcc";

 nativeBuildInputs = [
   i386-elf-gcc
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
