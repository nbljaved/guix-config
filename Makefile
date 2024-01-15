all: sync

sync:
	cat /etc/config.scm > config.scm
	cat "${HOME}/.config/guix/channels.scm" > channels.scm
	guix package --export-manifest > currrent-profile-manifest
