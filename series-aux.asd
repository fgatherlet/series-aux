#|
  This file is a part of series-aux project.
  Copyright (c) 2019 fgatherlet (fgatherlet@gmail.com)
|#

#|
  series-aux.

  Author: fgatherlet (fgatherlet@gmail.com)
|#

(defsystem "series-aux"
  :version "0.1.0"
  :author "fgatherlet"
  :license "MIT"
  :depends-on ("series"
               "let-over-lambda"
               "alexandria")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "main")
                 )))
  :description "series-aux."
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "series-aux-test"))))
