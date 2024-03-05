{ pkgs, ... }:
let
  # Import the Nix Library
  lib = pkgs.lib;

  # Define your aliases.
  aliases = [
    { alias = "md-watch"; command = "marp -w src/markdown"; }
    { alias = "md-edit"; command = "marktext src/markdown &"; }
    { alias = "md-preview"; command = "md-preview firefox src/markdown/*.html"; }
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
	# md-watch
	# md-edit
	# md-preview
  ] ++ mapAliases;

  shellHook = ''
    echo "
    Commands:
	  md-watch: Watch markdown files and generate HTML
	  md-edit: Open markdown files in Mark Text
	  md-preview: Open generated HTML files in Firefox
	  "
  '';
}
