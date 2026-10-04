;; Extra packages for the thinkpad, which runs Guix on Debian (see
;; REINSTALL-thinkpad.org).  On Guix System these were system packages in
;; config-thinkpad.scm; on Debian they must come from the user profile.
;;
;; The rest of config-thinkpad.scm's system packages come from apt
;; instead: git, curl, i3lock (needs Debian's PAM), tailscale, docker/podman
;; and nix.  emacs is covered by "nbl-emacs" in the shared manifest.
;;
;; Apply together with the shared manifest; `make apply-guix-profile`
;; does this on the thinkpad:
;;   guix package -m current-profile-manifest -m thinkpad-manifest.scm -L modules

(specifications->manifest
 (list "font-dejavu"
       "font-fira-code"
       "fontconfig"
       "sbcl"
       "stumpwm-with-slynk"))
