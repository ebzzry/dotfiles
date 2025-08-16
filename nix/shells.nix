{
  nixpkgs,
  pkgs,
  ...
}:
with pkgs;
let
  comDeps = [
    which
    rlwrap
    file
    getopt
    less
    curl
    glib
    openssl
    zlib
  ];
  gfxLibs = [
    libGL
    libGLU
    meson
    glfw
  ];
  addComDeps = list: list ++ comDeps;
  haskellPkgs = haskell.packages."ghc910";
  stack-wrapped = symlinkJoin {
    name = "stack";
    paths = [ stack ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/stack \
        --add-flags "\
          --no-nix \
          --system-ghc \
          --no-install-ghc \
        "
    '';
  };
  haskellTools = [
    stack-wrapped
    haskellPkgs.ghc
    haskellPkgs.ormolu
    haskellPkgs.haskell-language-server
  ];
in
rec {
  lisp = mkShell {
    buildInputs =
      addComDeps [
        sbcl
        ecl
        cl-launch
        libfixposix
      ]
      ++ gfxLibs;
    LD_LIBRARY_PATH = nixpkgs.lib.strings.makeLibraryPath gfxLibs;
  };
  cl = lisp;
  haskell = mkShell {
    buildInputs = addComDeps haskellTools;
    LD_LIBRARY_PATH = lib.makeLibraryPath haskellTools;
  };
  hs = haskell;
  clojure = mkShell {
    buildInputs = addComDeps [
      leiningen
      babashka
    ];
  };
  clj = clojure;
  scheme = mkShell {
    buildInputs = addComDeps [
      chibi
      chicken
      gauche
      racket
      scsh
      chez
      gerbil-unstable
    ];
  };
  scm = scheme;
  javascript = mkShell {
    buildInputs = addComDeps [
      nodejs
      deno
    ];
  };
  js = javascript;
  postgresql = mkShell {
    buildInputs = addComDeps [
      postgresql
      pgloader
    ];
    LD_LIBRARY_PATH = lib.strings.makeLibraryPath [ openssl ];
  };
  sql = postgresql;
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
