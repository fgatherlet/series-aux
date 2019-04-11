(in-package :series-aux)

(defun series-group (n items)
  (multiple-value-call
      (lambda (&rest chunks)
        (apply #'map-fn
               t (lambda (&rest n-tuple)
                   n-tuple
                   )
               chunks))
    (chunk n n items)))

(defun series-nconc (obj)
  "easy implementation of series mapcan like function.
   ex: (series-can #z((1 2 3) (10 20)) => #z(1 2 3 10 20)
   it is not optimized."
  (declare (optimizable-series-function))
  (producing
   (out)
   ((in obj)
    (buffer nil))
   (loop
     (tagbody
        (when buffer (go eatbuf))
        (setq buffer (next-in in (terminate-producing)))
        (if buffer
            (go eatbuf)
            (go end))
      eatbuf
        (next-out out (car buffer))
        (setq buffer (cdr buffer))
        (go end)
      end
        ))))

(defun scan-directory (base)
  (declare (optimizable-series-function))
  (series-nconc
   (scan-fn
    '(values list list prev-depth)
    (lambda () (values nil (list base) 0))
    (lambda (prev-x directory-stack prev-depth)
      (block top
        (unless directory-stack
          (return-from top (values nil nil -1)))
        (let* ((target-directory (car directory-stack))
               (depth (1+ prev-depth))
               (files-and-directories (uiop:directory* (make-pathname :defaults target-directory :name :wild :type :wild)))
               (children (remove-if-not #'uiop:directory-pathname-p files-and-directories))
               (files (remove-if #'uiop:directory-pathname-p files-and-directories))
               )
          (values (mapcar (lambda (x) (list x depth)) (append children files))
                  (append (cdr directory-stack) children)
                  depth))))
    (lambda (prev-x directory-stack prev-depth)
      (and (null prev-x) (null directory-stack))))))


#|

(mapping ((x (scan-directory "~/service/site-js/src/")))
  (car x))

(nth-value
 0
 (let ((base "~/service/site-js/src/"))
   (series-nconc
    (scan-fn
     '(values list list prev-depth)
     (lambda () (values nil (list base) 0))
     (lambda (prev-x directory-stack prev-depth)
       (block top
         (unless directory-stack
           (return-from top (values nil nil -1)))
         (let* ((target-directory (car directory-stack))
                (depth (1+ prev-depth))
                (files-and-directories (uiop:directory* (make-pathname :defaults target-directory :name :wild :type :wild)))
                (children (remove-if-not #'uiop:directory-pathname-p files-and-directories))
                (files (remove-if #'uiop:directory-pathname-p files-and-directories))
                )
           (values (mapcar (lambda (x) (cons x depth)) (append children files))
                   (append (cdr directory-stack) children)
                   depth))))
     (lambda (prev-x directory-stack prev-depth)
       (and (null prev-x) (null directory-stack)))))
   ))




(defun scan-directory-aux (base)
  (scan-fn
   '(values list fixnum list)
   (lambda () (values (list base) 0  (list base)))
   (lambda (prev-x prev-depth directory-stack)
     (let* ((target-directory (car directory-stack))
            (files (uiop:directory-files target-directory))
            (directories (uiop:directory* (merge-pathnames "*/" target-directory))))
       (format t ">>file:~s~%" files)
       (values (append files directories) (1+ prev-depth) (append (cdr directory-stack) directories))
       ))
   (lambda (x depth directory-stack)
     (null directory-stack))
   ))

(defun scan-directory (base)
  (series-nconc (scan-directory-aux base)))
|#
