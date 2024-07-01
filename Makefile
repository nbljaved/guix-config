all: sync

sync: guix nix

guix:
	cat /etc/config.scm > config.scm
	cat "${HOME}/.config/guix/channels.scm" > channels.scm
	guix package --export-manifest > currrent-profile-manifest

nix:
	mkdir -p nix-config
	cat ~/.nix-channels > ./nix-config/nix-channels
	cat ~/.nix-profile/manifest.nix > ./nix-config/manifest.nix
