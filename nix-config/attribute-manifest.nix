# Installation: nix-env --install --remove-all --file ./nix-config/attribute-manifest.nix
# Generated from manifest.nix on Sunday 16 November 2025 02:52:50 PM IST
#
# To specify package versions, you can use overrideAttrs:
#   (pkgs.bun.overrideAttrs (old: { version = "1.3.2"; }))
#
{ pkgs ? import <nixos-unstable> {} }:

[
  pkgs.bun
  pkgs.devenv
  pkgs.gh
  pkgs.hello
  pkgs.kitty
  pkgs.shot-scraper
  pkgs.tinymist
  pkgs.uv
]
