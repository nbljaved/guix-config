#!/usr/bin/env bash

# Script to extract package names from manifest.nix and generate portable attribute-manifest.nix

set -euo pipefail

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MANIFEST_FILE="$PROJECT_ROOT/nix-config/manifest.nix"
OUTPUT_FILE="$PROJECT_ROOT/nix-config/attribute-manifest.nix"

# Check if manifest file exists
if [[ ! -f "$MANIFEST_FILE" ]]; then
    echo "Error: manifest file not found: $MANIFEST_FILE" >&2
    exit 1
fi

echo "Extracting package names from $MANIFEST_FILE..."

# Extract store paths using nix-instantiate
store_paths=$(nix-instantiate --eval --json --strict "$MANIFEST_FILE" | jq -r '.[]')

# Extract package names from store paths and sort them
package_names=()
while IFS= read -r path; do
    # Extract package name from store path
    # Pattern: /nix/store/hash-package-name-version
    package_name=$(echo "$path" | sed 's|.*/||' | sed 's|^[^-]*-||' | sed 's|-[0-9].*$||')
    package_names+=("$package_name")
done <<< "$store_paths"

# Sort package names alphabetically
IFS=$'\n' sorted_names=($(sort <<<"${package_names[*]}"))
unset IFS

echo "Found packages: ${sorted_names[*]}"

# Generate the attribute-manifest.nix file
cat > "$OUTPUT_FILE" << EOF
# Installation: nix-env --install --remove-all --file ./nix-config/attribute-manifest.nix
#
# To specify package versions, you can use overrideAttrs:
#   (pkgs.bun.overrideAttrs (old: { version = "1.3.2"; }))
#
{ pkgs ? import <nixos-unstable> {} }:

[
EOF

# Add packages to the manifest - all from unstable channel
for package in "${sorted_names[@]}"; do
    echo "  pkgs.$package" >> "$OUTPUT_FILE"
done

# Close the list
echo "]" >> "$OUTPUT_FILE"

echo "Generated portable manifest: $OUTPUT_FILE"
echo "To install: nix-env --install --remove-all --file ./nix-config/attribute-manifest.nix"
