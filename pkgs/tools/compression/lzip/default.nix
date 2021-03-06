{ lib, stdenv, fetchurl, texinfo }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

stdenv.mkDerivation rec {
  pname = "lzip";
  version = "1.21";

  nativeBuildInputs = [ texinfo ];

  src = fetchurl {
    url = "mirror://savannah/lzip/${pname}-${version}.tar.gz";
    sha256 = "12qdcw5k1cx77brv9yxi1h4dzwibhfmdpigrj43nfk8nscwm12z4";
  };

  configureFlags = [
    "CPPFLAGS=-DNDEBUG"
    "CFLAGS=-O3"
    "CXXFLAGS=-O3"
  ] ++ lib.optional (stdenv.hostPlatform != stdenv.buildPlatform)
    "CXX=${stdenv.cc.targetPrefix}c++";

  setupHook = ./lzip-setup-hook.sh;

  doCheck = true;
  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.nongnu.org/lzip/lzip.html";
    description = "A lossless data compressor based on the LZMA algorithm";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
}
