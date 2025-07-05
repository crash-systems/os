{
  stdenv,
  fetchFromRepoOrCz,
  lib,
  i386-elf-binutils,
  ...
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "i386-elf-tcc";
  version = "0.9.27";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    rev = "f6385c05308f715bdd2c06336801193a21d69b50";
    hash = "sha256-tO3N+NplYy8QUOC2N3x0CO5Ui75j9bQzLSZQF1HQyhY=";
  };

  buildInputs = [ i386-elf-binutils ];

  target = "i686-elf";

  makeFlags = [ "i386-tcc" ];

  configureFlags = [
    "--target=${finalAttrs.target}"
    "--disable-shared"
    "--disable-werror"
    "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
    "--sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include"
    "--enable-cross"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Tiny C Compiler cross-compiled for i686-elf target";
    homepage = "https://bellard.org/tcc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "i386-tcc";
  };
})
