#!/usr/bin/env -S sh

## Example setting
# alias uv="$HOME/guix-config/scripts/uv-guix-shell.sh"

guix shell -CNF -E PATH --share=$HOME gcc-toolchain bash which coreutils  -- uv "$@"
