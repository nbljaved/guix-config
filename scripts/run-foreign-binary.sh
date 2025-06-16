#!/usr/bin/env -S bash
set -x -e

echo See https://zie87.github.io/posts/guix-foreign-binaries/

binary=$(which "$1")
echo looking at binary: "$binary"

path=$(patchelf --print-interpreter "$binary")
echo "$path"


patchelf --set-interpreter "$(patchelf --print-interpreter "$(realpath "$(which sh)")")" "$binary"

echo The following libraries are 'not found':
not_found_libs=()
while IFS= read -r line; do
    not_found_libs+=("$line")
done < <(guix shell gcc-toolchain -- ldd "$binary" | grep 'not found' | awk '{print $1}')
echo $not_found_libs

for lib in "${not_found_libs[@]}"; do
    # Get the first line of guix locate output, extract the path, then get its directory
    lib_path_dir=$(guix locate "$lib" | head -n 1 | awk '{print $2}' | xargs dirname)
    echo "Directory for $lib: $lib_path_dir"
    # You can now act on $lib_path_dir, e.g., add it to LD_LIBRARY_PATH if needed
    patchelf --set-rpath "$lib_path_dir" "$binary"
done
