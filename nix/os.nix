{
  stdenvNoCC,
  gcc-686,
  binutils-686,
  grub2,
  libisoburn,
}:
stdenvNoCC.mkDerivation {
 pname = "os";
 version = "0.0.1";

 src = ./..;

 env.CC = "i686-elf-gcc";

 nativeBuildInputs = [
   gcc-686
   binutils-686
   grub2
   libisoburn
 ];

 installPhase = ''
   runHook preInstall

   install -Dm577 os.iso $out/iso/os.iso

   runHook postInstall
'';
}
