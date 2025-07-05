{
  stdenv,
  gmp,
  mpfr,
  libmpc,
  fetchzip,
  lib,
  i386-elf-binutils,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "i386-elf-gcc";
  version = "10.2.0";

  src = fetchzip {
    url = "http://ftp.gnu.org/gnu/gcc/gcc-${finalAttrs.version}/gcc-${finalAttrs.version}.tar.gz";
    hash = "sha256-xMTbZEEyj0eS3Dkdi6izA88igcSm5arkuM+Xr0xINlA=";
  };

  preConfigure = ''
    mkdir build
    cd build
  '';

  configureScript = "../configure";

  configureFlags = [
    "--target=i386-elf"
    "--prefix=${placeholder "out"}"
    "--enable-languages=c"
    "--disable-bootstrap"
    "--disable-gcov"
    "--disable-libatomic"
    "--disable-libcc1"
    "--disable-libitm"
    "--disable-libgomp"
    "--disable-libmudflap"
    "--disable-libquadmath"
    "--disable-libmudflap"
    "--disable-libsanitizer"
    "--disable-libssp"
    "--disable-libstdcxx"
    "--disable-libstdcxx-pch"
    "--disable-libstdcxx-verbose"
    "--disable-multilib"
    "--disable-nls"
    "--disable-shared"
    "--disable-threads"
    "--without-headers"
    "--with-newlib"
    "--with-as=${lib.getExe' i386-elf-binutils "i386-elf-as"}"
    "--with-ld=${lib.getExe' i386-elf-binutils "i386-elf-ld"}"
  ];

  enableParallelBuilding = true;
  hardeningDisable = ["all"];

  buildInputs = [ i386-elf-binutils ];

  nativeBuildInputs = [
    gmp
    mpfr
    libmpc
    stdenv.cc
  ];

  makeFlags = [
    "all-gcc"
    "all-target-libgcc"
  ];

  installFlags = [
    "install-gcc"
    "install-target-libgcc"
  ];

  meta = {
    description = "GNU Compiler Collection";
    license = lib.licenses.gpl3Plus;
    mainProgram = "i386-elf-gcc";
  };
})
