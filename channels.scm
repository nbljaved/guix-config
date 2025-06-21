(cons* (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        ;; Enable signature verification:
        (introduction
         (make-channel-introduction
          "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
       (channel
        (name 'rde)
        (url "https://git.sr.ht/~abcdw/rde")
        (introduction
         (make-channel-introduction
          "257cebd587b66e4d865b3537a9a88cccd7107c95"
          (openpgp-fingerprint
           "2841 9AC6 5038 7440 C7E9  2FFA 2208 D209 58C1 DEB0"))))
       ;; (channel
       ;;  (name 'nbl)
       ;;  (url (string-append "file://" (getenv "HOME")
       ;;                      "/guix-config"))
       ;;  (directory "nbl")
       ;;  (branch "main"))
       (channel
        (name 'tailscale)
        (url "https://github.com/umanwizard/guix-tailscale")
        (branch "main")
        (commit "d0b1b05fdcf1407da72db803bf08fa6f223f9bae")
        (introduction
         (make-channel-introduction
          "c72e15e84c4a9d199303aa40a81a95939db0cfee"
          (openpgp-fingerprint
           "9E53FC33B8328C745E7B31F70226C10D7877B741"))))
       %default-channels)
