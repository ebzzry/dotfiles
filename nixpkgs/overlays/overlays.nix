self: super: {
  chromium = super.chromium.override {
  };

  emacs = super.emacs.override {
    withGTK2 = false;
    withGTK3 = false;
    withXwidgets = false;
  };

  gmrun = super.callPackage ./pkgs/gmrun { };

  kapo = super.callPackage ./pkgs/kapo { };

  kilolisp = super.callPackage ./pkgs/kilolisp { };

  racket = super.racket.override {
    disableDocs = false;
  };

  #sbcl = super.callPackage ./pkgs/sbcl { };
}
