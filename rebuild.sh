#!/bin/bash

find . -name '*.elc' -exec rm {} \;

(
cd cc-mode
emacs -batch -no-site-file -q -f batch-byte-compile cc-*.el
)

emacs --batch --eval '(byte-recompile-directory "./elisp" 0)'

(
cd elisp/auto-complete-1.3.1
find . -name '*.elc' -exec rm {} \;
make
)
