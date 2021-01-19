{ stdenv, lib, callPackage, fetchurl, fetchpatch }:

let
  common = opts: callPackage (import ./common.nix opts) {};
in

rec {
  firefox = common rec {
    pname = "firefox";
    ffversion = "84.0.2";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "2cxybnrcr0n75hnw18rrymw1jsd5crqfgnpk10hywbmnkdc72fx5sk51cg890pzwfiagicxfxsacnm3f6g8135k0wsz4294xjjwkm1z";
    };
    profdata = fetchurl {
      url = "https://firefox-ci-tc.services.mozilla.com/api/index/v1/task/gecko.v2.mozilla-release.revision.7e22d68e1ebfc0839092237feeefad46cfbd8651.firefox.linux64-profile/artifacts/public/build/profdata.tar.xz";
      sha512 = "ba48fd5f8b4e375d97d06d7c326c5d0ee59e1074c69915369cf124b7917200603d6fbeab4e413d6ba1799f7ce6585be2d07be6f6f0a0c747f5d542dc997b55b3";
    };

    meta = {
      description = "A web browser built from Firefox source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-unwrapped";
      versionKey = "ffversion";
    };
  };

  firefox-esr-78 = common rec {
    pname = "firefox-esr";
    ffversion = "78.6.1esr";
    src = fetchurl {
      url = "mirror://mozilla/firefox/releases/${ffversion}/source/firefox-${ffversion}.source.tar.xz";
      sha512 = "3kq9vb0a8qblqk995xqhghw5d694mr1cjd5alkkwxbdjhpc1mck0ayn40xjph0znga6qdcq8l366p0by8ifbsdhv0x39ng8nvx9jvdf";
    };

    meta = {
      description = "A web browser built from Firefox Extended Support Release source tree";
      homepage = "http://www.mozilla.com/en-US/firefox/";
      maintainers = with lib.maintainers; [ eelco ];
      platforms = lib.platforms.unix;
      badPlatforms = lib.platforms.darwin;
      broken = stdenv.buildPlatform.is32bit; # since Firefox 60, build on 32-bit platforms fails with "out of memory".
                                             # not in `badPlatforms` because cross-compilation on 64-bit machine might work.
      license = lib.licenses.mpl20;
    };
    updateScript = callPackage ./update.nix {
      attrPath = "firefox-esr-78-unwrapped";
      versionKey = "ffversion";
    };
  };
}
