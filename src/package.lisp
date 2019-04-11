;; (ql:quickload '(:series))

(defpackage series-aux
  (:export
   :series-nconc
   :scan-directory
   )
  (:use
   :cl
   :series
   ))
(in-package :series-aux)
