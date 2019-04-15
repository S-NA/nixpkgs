{ stdenv, fetchurl, autoPatchelfHook, python, sqlite, tlf, zlib }:

stdenv.mkDerivation rec {
  name = "infer-${version}";
  version = "0.15.0";

  src = fetchurl {
    url = "https://github.com/facebook/infer/releases/download/v${version}/infer-linux64-v${version}.tar.xz";
    sha256 = "12mi9hhzwwvwq11iwxphzkgfa4i38xdbna2maj65wwr754b9iszn";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs       = [ python sqlite stdenv.cc.cc.lib tlf zlib ];

  # Workaround for https://github.com/NixOS/patchelf/issues/99
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,share}
    cp -r ./{bin,lib,share} $out
    autoPatchelf $out/lib/infer/infer
  '';

  meta = with stdenv.lib; {
    homepage = https://fbinfer.com/;
    description = "A static analyzer for Java, C, C++, and Objective-C";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ sna ];
  };
}
