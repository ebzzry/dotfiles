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
  haskellPkgs = haskell.packages."ghc984";
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
    haskellPkgs.ghcid
    haskellPkgs.ormolu
    haskellPkgs.hlint
    haskellPkgs.haskell-language-server
    haskellPkgs.implicit-hie
    haskellPkgs.retrie
    haskellPkgs.hoogle
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
  haskell = mkShell {
    buildInputs = addComDeps haskellTools;
    LD_LIBRARY_PATH = lib.makeLibraryPath haskellTools;
  };
  clojure = mkShell {
    buildInputs = addComDeps [
      leiningen
      babashka
    ];
  };
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
  javascript = mkShell {
    buildInputs = addComDeps [
      nodejs
      deno
    ];
  };
  postgresql = mkShell {
    buildInputs = addComDeps [
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
