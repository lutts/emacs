#!/bin/bash

emacs --batch --eval '(byte-recompile-directory "~/emacs/elisp" 0)'

# emacs --batch --eval '(byte-compile-file "your-elisp-file.el")'
