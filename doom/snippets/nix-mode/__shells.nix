{ nixpkgs, pkgs, ... }:
with pkgs; rec {
  lisp = mkShell { buildInputs = [ sbcl ]; };
  default = lisp;
}
