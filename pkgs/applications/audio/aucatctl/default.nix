{ stdenv, fetchurl, sndio, libbsd }:

let
  inherit (stdenv.lib) optional;

in stdenv.mkDerivation rec {
  name = "aucatctl-${version}";
  version = "0.1";
  src = fetchurl {
    url = "http://www.sndio.org/${name}.tar.gz";
    sha256 = "524f2fae47db785234f166551520d9605b9a27551ca438bd807e3509ce246cf0";
  };

  buildInputs = [ sndio libbsd ];

  # When defining outputs, a set of flags are automatically enabled.
  # For the most part this is useful; however, some of these flags cause the
  # configure script to return a status code of an error due to not being
  # flags which are undefined. To work around this we patch out the unknown
  # flags case in the switch statement.

  #  preConfigure = ''
  #    sed -i s/help$//g configure
  #    sed -i 's/exit 1$//g' configure
  #  '';
  #
  #  configureFlags = [
  #    "--mandir=$(doc)/man"
  #  ];

  preBuild = ''
    sed -i 's/-lsndio/-lsndio -lbsd/g' Makefile
    sed -i 's#/usr/local#$(out)#g' Makefile
  '';

  meta = with stdenv.lib; {
    description = "The aucatctl utility sends MIDI messages to control sndiod and/or aucat volumes";
    homepage = http://www.sndio.org;
    license = licenses.isc;
    maintainers = with maintainers; [ sna ];
    platforms = platforms.unix;
  };
}
