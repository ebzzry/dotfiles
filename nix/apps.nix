{ pkgs }:
rec {
  hello = {
    type = "app";
    program = "${pkgs.hello}/bin/hello";
  };
  default = hello;
}
