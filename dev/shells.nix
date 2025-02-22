{
  nixpkgs,
  pkgs,
  ...
}:
with pkgs;
let
  gfxLibs = [
    libGL
    libGLU
    meson
    glfw
  ];
  addLibs =
    list:
    list
    ++ [
      which
      rlwrap
      file
      getopt
      less
      curl
      git
      glib
      openssl
    ];
in
rec {
  lisp = mkShell {
    buildInputs =
      addLibs [
        sbcl
        ecl
        cl-launch
        libfixposix
      ]
      ++ gfxLibs;
    LD_LIBRARY_PATH = nixpkgs.lib.strings.makeLibraryPath gfxLibs;
  };
  clojure = mkShell {
    buildInputs = addLibs [
      leiningen
      babashka
    ];
  };
  scheme = mkShell {
    buildInputs = addLibs [
      chibi
      chicken
      gauche
      racket
      scsh
      chez
      gerbil-unstable
    ];
  };
  javascript = mkShell {
    buildInputs = addLibs [
      nodejs
      deno
    ];
  };
  haskell = mkShell { buildInputs = addLibs [ haskellPackages.ghc ]; };
  postgresql = mkShell {
    buildInputs = addLibs [
      postgresql
      pgloader
    ];
    LD_LIBRARY_PATH = lib.strings.makeLibraryPath [ openssl ];
  };
  www = mkShell {
    buildInputs = [
      gnumake
      cl-launch
      emem
      parallel
    ];
  };
  default = lisp;
}
