{
  pkgs,
  system,
  ...
}: let
  slides = derivation {
    inherit system;

    name = "nix-foundations";
    src = ../src;

    args = [
      "-c"
      ''
        set -x
        ${pkgs.coreutils}/bin/mkdir -p $out/bin/images
        ${pkgs.coreutils}/bin/cp -r $src/images/* $out/bin/images
        ${pkgs.marp-cli}/bin/marp $src/markdown/00-nix-foundations.md -o $out/bin/html/index.html
      ''
    ];

    builder = "${pkgs.bash}/bin/bash";
  };
in
  pkgs.writeShellScriptBin "show" ''
    ${pkgs.firefox}/bin/firefox ${slides}/bin/html/index.html
  ''
