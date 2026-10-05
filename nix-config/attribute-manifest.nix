# Installation: nix-env --install --remove-all --file ./nix-config/attribute-manifest.nix
#
# To specify package versions, you can use overrideAttrs:
#   (pkgs.bun.overrideAttrs (old: { version = "1.3.2"; }))
#
{ pkgs ? import <nixos-unstable> {} }:

[
  pkgs.backrest
  pkgs.bun
  pkgs.claude-code
  pkgs.devenv
  pkgs.gh
  pkgs.hello
  pkgs.kitty
  pkgs.opencode
  pkgs.pnpm
  # rage: the Rust implementation of age.  It is here rather than in the Guix
  # manifest because Guix's `rage` is Enlightenment's video player; this one
  # supports pinentry, which age.el needs for passphrase-protected age
  # identities and files (the age reference implementation refuses by design).
  pkgs.rage
  pkgs.rclone
  pkgs.restic
  pkgs.scrcpy
  pkgs.tinymist
  pkgs.uv
]
