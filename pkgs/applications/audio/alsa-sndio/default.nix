{ stdenv, fetchFromGitHub, alsaLib, sndio, pkgconfig }:

stdenv.mkDerivation rec {
  name = "alsa-sndio";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "Duncaen";
    repo = "alsa-sndio";
    rev = "${version}";
    sha256 = "01yvbdskfgfg5nvd7fm759gd54x2y6v0r90j7n0acdc7r4iwv75d";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ alsaLib sndio ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/Duncaen/alsa-sndio;
    description = "ALSA PCM to play audio on sndio servers";
    license = licenses.isc;
    maintainers = [ maintainers.sna ];
    platforms = platforms.linux;
  };
}

