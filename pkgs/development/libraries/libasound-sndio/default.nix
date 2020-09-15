{ stdenv, fetchFromGitHub, sndio, gnum4 }:

stdenv.mkDerivation rec {
  pname = "libasound-sndio";
  version = "2020-03-14";

  src = fetchFromGitHub {
    owner = "Cloudef";
    repo = pname;
    rev = "934421ad735c23b00d881079f80728762e6fae43";
    sha256 = "0ndyqwy6y8r1fis87qjdp836wacz42xky4z7h1p2ghddj71a2dkr";
  };

  buildInputs = [ sndio gnum4 ];

  makeFlags = [ "PREFIX=$(out)" "DESTDIR=" ];

  patchPhase = ''
    substituteInPlace alsa.pc.in \
      --replace "/lib" "" --replace "/include" "" \
      --replace '$${libdir}' "${placeholder "out"}/lib" \
      --replace '$${includedir}' "${placeholder "out"}/include"
  '';

  postFixup = ''
    cd $out/include/alsa
    cp asoundlib.h ..
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/Cloudef/libasound-sndio";
    description = "libasound implementation that uses sndio";

    longDescription = ''
      libasound implementation that uses sndio (not full implementation, but
      hopefully enough to replace the real thing eventually)
    '';

    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
