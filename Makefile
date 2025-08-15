HOSTNAME := $(shell hostname)
GUIX_SYSTEM := $(shell grep '^ID=guix' /etc/os-release)

all: sync

sync: guix nix

guix:
ifeq ($(HOSTNAME), thinkpad)
	cat /etc/config.scm > config-thinkpad.scm
else
	# not thinkpad
endif
ifeq ($(HOSTNAME), pc)
	cat /etc/config.scm > config-pc.scm
else
	# not pc
endif
# cat /etc/xremap.yaml > xremap.yaml
	ln -sf ~/guix-config/channels.scm ~/.config/guix/channels.scm
	# TODO: The following command doesn't work:
	# guile ./scripts/sort-manifest.scm  current-profile-manifest > current-profile-manifest
	#
	# Can't read from same file as bash due to the 'redirection'
	# truncates the output file to zero length, therefore we need
	# to use 'sponge' from moreutils that sponges up all the output
	# from the pipe before opening the output file for writing
	#
	# guile ./scripts/sort-manifest.scm  current-profile-manifest | sponge current-profile-manifest
	guile ./scripts/sort-manifest.scm > current-profile-manifest

nix:
ifdef GUIX_SYSTEM
	mkdir -p nix-config
	cat ~/.nix-channels > ./nix-config/nix-channels
	cat ~/.nix-profile/manifest.nix > ./nix-config/manifest.nix
else
	# Not a Guix system, therefore no nix-service-type
endif

echo:
	echo $(HOSTNAME) > /dev/null
	echo $(GUIX_SYSTEM) > /dev/null
