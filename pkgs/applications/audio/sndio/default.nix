{ stdenv, fetchurl, alsaLib, CoreAudio }:

let
  inherit (stdenv.lib) optional;

in stdenv.mkDerivation rec {
  name = "sndio-${version}";
  version = "1.5.0";
  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "0lyjb962w9qjkm3yywdywi7k2sxa2rl96v5jmrzcpncsfi201iqj";
  };

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  buildInputs = [ ]
    ++ optional stdenv.isLinux alsaLib
    ++ optional stdenv.isDarwin CoreAudio;

  # When defining outputs, a set of flags are automatically enabled.
  # For the most part this is useful; however, some of these flags cause the
  # configure script to return a status code of an error due to not being
  # flags which are undefined. To work around this we patch out the unknown
  # flags case in the switch statement.
  preConfigure = ''
    sed -i s/help$//g configure
    sed -i 's/exit 1$//g' configure
  '';

  configureFlags = [
    "--mandir=$(doc)/man"
  ];

  meta = with stdenv.lib; {
    description = "Small audio and MIDI framework from the OpenBSD project";
    homepage = http://www.sndio.org;
    license = licenses.isc;
    maintainers = with maintainers; [ sna ];
    platforms = platforms.unix;
  };
}
