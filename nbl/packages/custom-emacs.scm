;; custom-emacs.scm

(use-modules (guix packages)
             (gnu packages emacs)
             (gnu packages xorg))

(define-public nbl-emacs
  (package
   (inherit emacs)
   (inputs (modify-inputs (package-inputs emacs)
                          (prepend libxaw)))))

nbl-emacs
