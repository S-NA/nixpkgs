{ stdenv, fetchurl, alsaLib, CoreAudio }:

let
  inherit (stdenv.lib) optional;

in stdenv.mkDerivation rec {
  name = "sndio-${version}";
  version = "1.4.0";
  src = fetchurl {
    url = "http://www.sndio.org/sndio-${version}.tar.gz";
    sha256 = "10cpixvxc22ypknhh19lv81hiysl82rf2k0gkkvbyzbr4jv3swb8";
  };

  buildInputs = [ ]
    ++ optional stdenv.isLinux alsaLib
    ++ optional stdenv.isDarwin CoreAudio;

  meta = with stdenv.lib; {
    description = "Small audio and MIDI framework from the OpenBSD project";
    homepage = http://www.sndio.org;
    license = licenses.isc;
    maintainers = with maintainers; [ sna ];
    platforms = platforms.unix;
  };
}
