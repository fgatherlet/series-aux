#|
  This file is a part of series-aux project.
  Copyright (c) 2019 fgatherlet (fgatherlet@gmail.com)
|#

(defsystem "series-aux-test"
  :defsystem-depends-on ("prove-asdf")
  :author "fgatherlet"
  :license "MIT"
  :depends-on ("series-aux"
               "prove")
  :components ((:module "t"
                :components
                ((:test-file "test"))))
  :description "Test system for series-aux"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
