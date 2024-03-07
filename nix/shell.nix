{ pkgs, ... }:
let
  # Import the Nix Library
  lib = pkgs.lib;

  # Define your aliases.
  aliases = [
    { alias = "md-watch"; command = "marp -w src/markdown"; }
    { alias = "md-edit"; command = "marktext src/markdown &"; }
  ];

  # Adjust the transformation function to return the correct structure.
  aliasToCommand = { alias, command }: pkgs.writeShellScriptBin alias command;

  # Apply the transformation function to each element in the list.
  mapAliases = map aliasToCommand aliases;
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    marp-cli
    firefox
    marktext
  ] ++ mapAliases;

  shellHook = ''
    echo "
    Commands:
	  md-watch: Watch markdown files and generate HTML
	  md-edit: Open markdown files in Mark Text
	  "
  '';
}
