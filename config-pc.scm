;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules 
 (gnu)
 (gnu packages package-management)
 (gnu packages bash)
 (gnu packages admin)
 (gnu packages lisp-xyz)
 (gnu packages rust-apps)
 (gnu packages wm)
 (gnu services shepherd)
 (nongnu packages linux)
 (nongnu packages firmware)
 (nongnu system linux-initrd)
 (srfi srfi-1)
 (guix inferior)
 (guix channels))

(use-package-modules
 curl
 docker
 emacs
 fonts
 lisp
 version-control
 wm)

(use-service-modules
 cups
 databases
 desktop
 docker
 networking
 nix
 ssh
 xorg)

(operating-system
 (kernel linux)
 (initrd microcode-initrd)
 (firmware (list linux-firmware))
 (locale "en_IN.utf8")
 (timezone "Asia/Kolkata")
 (keyboard-layout (keyboard-layout "us" "altgr-intl"))
 (host-name "pc")

 ;; The list of user accounts ('root' is implicit).
 (users (cons* (user-account
                (name "nabeel")
                (comment "Nabeel Javed")
                (group "users")
                (home-directory "/home/nabeel")
                (shell (file-append bash "/bin/bash"))
                (supplementary-groups '("wheel" ;allow use of sudo, etc.
                                        "tty"
                                        "netdev"
                                        "lp" ;Users need to be in the lp group to access the D-Bus service, like bluetooth.
                                        "audio" ;sound card
                                        "video" ;video devices such as webcams
                                        "input"
                                        "docker"
                                        )))
               %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages (append (list curl
                         ;; docker
                         docker-cli
                         docker-compose
                         ;;
                         emacs
                         font-dejavu
                         font-fira-code
                         git
                         ;; nix (for devenv.sh and uv, etc.)
                         nix
                         ;;
                         ;; sway
                         ;; swaylock-effects
                         ;; swaybg
                         ;; swayidle
                         ;; waybar
                         ;; stumpwm
                         sbcl
                         (specification->package "stumpwm-with-slynk")
                         i3lock
                         ;; sbcl-slynk
                         ;; `(,stumpwm "lib")
                         ;; sbcl-stumpwm-ttf-fonts
                         xremap-x11
                         )
                   %base-packages))
 
 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (append (list (service xfce-desktop-service-type)
		;; To configure OpenSSH, pass an 'openssh-configuration'
                ;; record as a second argument to 'service' below.
                (service openssh-service-type
                         (openssh-configuration
                          ;; Currently the default is #t but it's considered
                          ;; unsafe.  Explicitly pass #f.
                          (password-authentication? #f)))
                (service bluetooth-service-type
                         (bluetooth-configuration
                          (auto-enable? #t)))
                (service cups-service-type)
                (service docker-service-type)
                ;; Have to manually add containerd service to use in docker.
                ;; https://lists.nongnu.org/archive/html/guix-patches/2024-06/msg00177.html
                (service containerd-service-type)
                (set-xorg-configuration
                 (xorg-configuration (keyboard-layout keyboard-layout)))
                (service screen-locker-service-type
                         (screen-locker-configuration
                          (name "i3lock")
                          (program (file-append i3lock "bin/i3lock"))
                          (using-pam? #t)
                          (using-setuid? #f)))
                (service nix-service-type))
	  ;; This is the default list of services we
	  ;; are appending to.
	  (modify-services %desktop-services
			   ;; enable wayland for gdm, gnome
			   (gdm-service-type config =>
					     (gdm-configuration
					      (inherit config)
					      (wayland? #f)))
			   (elogind-service-type
			    config =>
			    (elogind-configuration
			     (inherit config)
			     (handle-power-key 'suspend)))
			   ;; enable substitute for nonguix - should help with large package eg: linux, firefox
			   (guix-service-type config => (guix-configuration
							 (inherit config)
							 (substitute-urls
							  (append
							   (list
							    "https://substitutes.nonguix.org")
							   %default-substitute-urls))
							 (authorized-keys
							  (append
							   (list
							    (local-file
							     "./signing-key.pub"))
							   %default-authorized-guix-keys)))))))
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "27b860cf-aa15-4be6-b08f-6592fc8f0dc8")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "9591-0188"
                                     'fat32))
                       (type "vfat"))
                      (file-system
                       (mount-point "/")
                       (device (uuid
                                "41a31ef0-566b-4496-99aa-e4ce821def30"
                                'ext4))
                       (type "ext4")) %base-file-systems)))
