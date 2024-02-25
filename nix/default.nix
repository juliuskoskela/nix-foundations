{
  pkgs,
  system,
  ...
}: let
  slides = derivation {
    inherit system;

    name = "slides";
    src = ../slides;

    args = [
      "-c"
      ''
        set -x
        ${pkgs.coreutils}/bin/mkdir -p $out/bin/$name
        ${pkgs.coreutils}/bin/cp -r $src/* $out/bin/$name
        ${pkgs.marp-cli}/bin/marp $out/bin/$name
        ${pkgs.coreutils}/bin/rm -f $out/bin/$name/*.md
      ''
    ];

    builder = "${pkgs.bash}/bin/bash";
  };

  show = pkgs.writeShellScriptBin "show" ''
    ${pkgs.firefox}/bin/firefox ${slides}/bin/slides/*.html
  '';
in
  pkgs.symlinkJoin {
    name = "nix-foundations-slides";
    paths = [
      slides
      show
    ];
  }
