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
 (gnu packages wm)
 (nongnu packages linux)
 (nongnu packages firmware)
 (nongnu system linux-initrd)
 (packages tailscale)
 (services tailscale)
 (srfi srfi-1)
 (guix inferior)
 (guix channels))

(use-package-modules
 curl
 emacs
 fonts
 lisp
 version-control
 wm)

(use-service-modules
 cups
 desktop
 networking
 nix
 ssh
 xorg)

(operating-system
 (kernel
  ;; https://github.com/nonguix/nonguix#pinning-package-versions
  ;; 
  ;; When using substitutes is not an option, you may find that guix
  ;; system reconfigure recompiles the kernel frequently due to
  ;; version bumps in the kernel package. An inferior can be used to
  ;; pin the kernel version and avoid lengthy rebuilds.
  (let*
      ((channels
        (list (channel
               (name 'nonguix)
               (url "https://gitlab.com/nonguix/nonguix")
               (commit "143b597422bf01a8fa0e8b4e6e3ece3b3ebe9752"))
              (channel
               (name 'guix)
               (url "https://git.savannah.gnu.org/git/guix.git")
               (commit "7daf9328921f9f7d4fe4839d8e16091bd9f06072"))))
       (inferior
        (inferior-for-channels channels)))
    (first (lookup-inferior-packages inferior "linux" "6.9.3"))))
 (initrd microcode-initrd)
 ;; includes iwlwif, intel microcode
 (firmware (list linux-firmware))  
 (locale "en_IN.utf8")
 (timezone "Asia/Kolkata")
 (keyboard-layout (keyboard-layout "us" "altgr-intl"))
 (host-name "nabeel")

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
                                        "lp"    ;Users need to be in the lp group to access the D-Bus service, like bluetooth. 
                                        "audio" ;sound card
                                        "video" ;video devices such as webcams
                                        "input"
                                        )))
               %base-user-accounts))

 ;; Packages installed system-wide.  Users can also install packages
 ;; under their own account: use 'guix search KEYWORD' to search
 ;; for packages and 'guix install PACKAGE' to install a package.
 (packages (append (list curl
                         emacs
                         font-dejavu
                         font-fira-code
                         git
                         nix
                         sway
                         swaylock-effects
                         swaybg
                         swayidle
                         waybar
                         tailscale
                         ;; stumpwm
                         sbcl
                         (specification->package "stumpwm-with-slynk")
                         i3lock
                         ;; sbcl-slynk
                         ;; `(,stumpwm "lib")
                         ;; sbcl-stumpwm-ttf-fonts
                         )
                   %base-packages))

 ;; Below is the list of system services.  To search for available
 ;; services, run 'guix system search KEYWORD' in a terminal.
 (services
  (append (list (service gnome-desktop-service-type)
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
                (set-xorg-configuration
                 (xorg-configuration (keyboard-layout keyboard-layout)))
                (service screen-locker-service-type
                         (screen-locker-configuration
                          (name "swaylock")
                          (program (file-append swaylock "bin/swaylock"))
                          (using-pam? #t)
                          (using-setuid? #f)))
                (service screen-locker-service-type
                         (screen-locker-configuration
                          (name "i3lock")
                          (program (file-append swaylock "bin/i3lock"))
                          (using-pam? #t)
                          (using-setuid? #f)))
                (service nix-service-type)
                (service tailscaled-service-type))

          ;; This is the default list of services we
          ;; are appending to.
          (modify-services %desktop-services
                           ;; enable wayland for gdm, gnome 
                           (gdm-service-type config =>
                                             (gdm-configuration
                                              (inherit config)
                                              (wayland? #f)))
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
                                                           %default-authorized-guix-keys))))))
  )
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets (list "/boot/efi"))
              (keyboard-layout keyboard-layout)))
 (swap-devices (list (swap-space
                      (target (uuid
                               "b1411533-b4e5-4f41-8bc4-cce90b425870")))))

 ;; The list of file systems that get "mounted".  The unique
 ;; file system identifiers there ("UUIDs") can be obtained
 ;; by running 'blkid' in a terminal.
 (file-systems (cons* (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "19EA-A6BA"
                                     'fat32))
                       (type "vfat"))
                      (file-system
                       (mount-point "/")
                       (device (uuid
                                "b54d30b2-e4fe-4385-8518-cca7a28746ab"
                                'ext4))
                       (type "ext4")) %base-file-systems)))
