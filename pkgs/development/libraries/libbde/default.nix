{ stdenv, fetchurl, autoreconfHook, pkgconfig, fuse }:

stdenv.mkDerivation rec {
  pname = "libbde";
  version = "20191221";

  src = fetchurl {
    url = "https://github.com/libyal/${pname}/releases/download/${version}/${pname}-alpha-${version}.tar.gz";
    sha256 = "0v1b7xzph2hacwxkr94m5xzh2y7dk45vxhaw8vgl085d60k8xc5a";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig fuse ];

  outputs = [ "bin" "dev" "out" "man" ];

  meta = {
    homepage = "https://github.com/libyal/libbde";
    description = "Library and tools to access the BitLocker Drive Encryption (BDE) encrypted volumes";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
