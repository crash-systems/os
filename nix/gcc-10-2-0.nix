{
  stdenv,
  gmp,
  mpfr,
  libmpc,
  fetchzip,
  lib,
  binutils-686,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gcc";
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
    "--target=i686-elf"
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
    "--with-as=${lib.getExe' binutils-686 "i686-elf-as"}"
    "--with-ld=${lib.getExe' binutils-686 "i686-elf-ld"}"
  ];

  enableParallelBuilding = true;
  hardeningDisable = ["all"];

  buildInputs = [ binutils-686 ];

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
    mainProgram = "i686-elf-gcc";
  };
})
