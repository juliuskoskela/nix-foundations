{
  pkgs,
  system,
  ...
}: let
  slides = derivation {
    inherit system;

    name = "slides";
    src = ../slides/nix-fundamentals.md;

    args = [
      "-c"
      ''
        set -x
        ${pkgs.coreutils}/bin/mkdir -p $out/bin/$name
        ${pkgs.marp-cli}/bin/marp $src -o $out/bin/$name
      ''
    ];

    builder = "${pkgs.bash}/bin/bash";
  };

  show = pkgs.writeShellScriptBin "nix-fundamentals" ''
    ${pkgs.firefox}/bin/firefox ${slides}/bin/slides
  '';
in
  pkgs.symlinkJoin {
    name = "nix-fundamentals";
    paths = [
      slides
      show
    ];
  }
