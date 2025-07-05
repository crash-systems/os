{
  stdenv,
  fetchzip,
  lib,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "i386-elf-binutils";
  version = "2.36";

  src = fetchzip {
    url = "http://ftp.gnu.org/gnu/binutils/binutils-${finalAttrs.version}.tar.gz";
    hash = "sha256-tSUy7k9CvsMdfzkKXvJYM2OxpipFK0RdUmrIevjsIRI=";
  };

  configureFlags = [
    "--target=i386-elf"
    "--prefix=${placeholder "out"}"
    "--enable-deterministic-archives"
    "--disable-nls"
    "--disable-gold"
    "--disable-plugins"
    "--disable-multilib"
    "--disable-gprofng"
    "--disable-libquadmath"
    "--disable-libstdcxx"
    "--disable-readline"
    "--disable-sim"
    "--disable-werror"
  ];

  enableParallelBuilding = true;
  hardeningDisable = ["all"];

  checkPhase = ''
    make test
  '';

  meta = {
    description = "System binary utilities";
    license = lib.licenses.gpl3Plus;
  };
})
