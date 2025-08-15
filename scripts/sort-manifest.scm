(use-modules (ice-9 pretty-print)
             (ice-9 textual-ports)
             (ice-9 popen)
             (srfi srfi-13))


;; Read the current manifest into a string
(define (current-manifest-string)
  (let* ((pipe (open-input-pipe "guix package --export-manifest"))
         (manifest (get-string-all pipe)))
    (close-pipe pipe)
    manifest))

;; Read file into string
(define (file->string file)
  (let* ((port (open-input-file file))
         (file-data (get-string-all port)))
    (close-port port)
    file-data))

;; If we call `guile this-file.scm some-filename`,
;; then return `some-filename`,
;; otherwise return #f
(define (get-filename)
  (let ((args (cdr (command-line))))
    (if (not (null? args))
        (car args)
        #f)))

;; If called with the some manifest's filename, sort that,
;; otherwise sort the current profile's manifest (returned
;; by `guix package --export-manifest`)
;; and print it to output.
(define (main)
  (let* ((filename (get-filename))
         (input-string (if filename
                           (file->string filename)
                           (current-manifest-string))))
    ;; Find the starting position of the S-expression.
    (let ((sexp-start (string-index input-string #\()))
      (if sexp-start
          (let* ((header (substring input-string 0 sexp-start))
                 (sexp-string (substring input-string sexp-start))
                 (manifest-data (read (open-input-string sexp-string))))
            ;; Check if the parsed data has the expected structure.
            (if (and (list? manifest-data)
                     (eq? 'specifications->manifest (car manifest-data))
                     (list? (cadr manifest-data))
                     (eq? 'list (caadr manifest-data)))
                (let* ((package-names (cdadr manifest-data))
                       (sorted-names (sort package-names string<?))
                       (sorted-manifest
                        `(specifications->manifest
                          (list ,@sorted-names))))
                  ;; Print the header and the sorted manifest.
                  (display header)
                  (pretty-print sorted-manifest))
                (begin
                  (display "Error: The S-expression does not have the expected format.\n" (current-error-port))
                  (display input-string))))
          (begin
            (display "Error: No S-expression found in the input.\n" (current-error-port))
            (display input-string))))))

;; Run the main function.
(main)
