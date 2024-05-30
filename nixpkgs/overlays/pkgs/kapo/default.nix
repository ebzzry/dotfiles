{ stdenv, fetchFromGitHub, bash }:

stdenv.mkDerivation rec {
  name = "kapo-${version}";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = "kapo";
    rev = "c89185e8039376fd3c7611a6e5a1fb83ea67b0f2";
    sha256 = "17dg1nsm6p3r7lbly2jfxkxfjw73188q8vjmbfb09slxvxvwqin2";
  };

  #buildInputs = [ shc ];

  dontStrip = false;

  buildPhase = ''
    substituteInPlace kapo --replace "/usr/bin/env bash" "${bash}/bin/bash"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kapo $out/bin
    chmod +x $out/bin/kapo
  '';

  meta = with stdenv.lib; {
    description = "Vagrant helper";
    homepage = https://github.com/ebzzry/kapo;
    license = licenses.cc0;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.all;
  };
}
