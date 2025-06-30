#!/usr/bin/env -S sh

## Example setting
# alias uv="$HOME/guix-config/scripts/uv-guix-shell.sh"

# `curl` requires `nss-certs`
# guix shell -CNF -E PATH --share=$HOME gcc-toolchain bash which coreutils curl nss-certs -- curl blah-blah....

# to run uv
guix shell -CNF -E PATH --share=$HOME gcc-toolchain bash which coreutils  -- uv "$@"
