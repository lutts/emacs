;; This is a way to hook tempo into cc-mode
(defvar c-tempo-tags nil
  "Tempo tags for C mode")

(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

;;; C-Mode Templates and C++-Mode Templates (uses C-Mode Templates also)
(require 'tempo)
(setq tempo-interactive t)
(global-set-key (kbd "C-=") 'tempo-complete-tag)

(add-hook 'c-mode-common-hook
	  '(lambda ()
	     (tempo-use-tag-list 'c-tempo-tags)))

(add-hook 'c++-mode-hook
	  '(lambda ()
	     (tempo-use-tag-list 'c-tempo-tags)
	     (tempo-use-tag-list 'c++-tempo-tags)))

(add-hook 'shell-script-mode-hook
	  '(lambda ()
	     (tempo-use-tag-list 'bash-tempo-tags)))

;;; Preprocessor Templates (appended to c-tempo-tags)
(tempo-define-template "c-include"
		       '("include <" r ".h>" > n
			 )
		       "include"
		       "Insert a #include <> statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifdef"
		       '("ifdef " (p "ifdef-clause: " clause) > n> p n
			 "#else /* !(" (s clause) ") */" n> p n
			 "#endif /* " (s clause)" */" n>
			 )
		       "ifdef"
		       "Insert a #ifdef #else #endif statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifndef"
		       '("ifndef " (p "ifndef-clause: " clause) > n
			 "#define " (s clause) p n
			 "#endif  // " (s clause) n>
			 )
		       "ifndef"
		       "Insert a #ifndef #define #endif statement"
		       'c-tempo-tags)

;;; C-Mode Templates

(tempo-define-template "c-if"
		       '(> "if(" (p "if-clause: " clause) ")"  n>
			   "{" > n> r n
			   "} /* end of if(" (s clause) ") */" > n>
			   )
		       "if"
		       "Insert a C if statement"
		       'c-tempo-tags)

(tempo-define-template "c-else"
		       '(> "else" n>
			   "{" > n> r n
			   "} /* end of else */" > n>
			   )
		       "else"
		       "Insert a C else statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-else"
		       '(> "if(" (p "if-clause: " clause) ")"  n>
			   "{" > n> r n
			   "} /* end of if(" (s clause) ") */" > n>
			   > "else" n>
			   "{" > n> r n
			   "} /* end of if(" (s clause) ")else */" > n>
			   )
		       "ifelse"
		       "Insert a C if else statement"
		       'c-tempo-tags)

(tempo-define-template "c-else-if"
		       '(> "else if(" (p "if-clause: " clause) ")" n>
			   "{" > n> r n
			   "} /* end of else if(" (s clause) " */" > n>
			   )
		       "elseif"
		       "Insert a C else if statement"
		       'c-tempo-tags)

(tempo-define-template "c-while"
		       '(> "while(" (p "while-clause: " clause) ")" >  n>
			   "{" > n> r n
			   "} /* end of while(" (s clause) ") */" > n>
			   )
		       "while"
		       "Insert a C while statement"
		       'c-tempo-tags)

(tempo-define-template "c-for"
		       '(> "for(" (p "for-clause: " clause) ")" >  n>
			   "{" > n> r n
			   "} /* end of for(" (s clause) ") */" > n>
			   )
		       "for"
		       "Insert a C for statement"
		       'c-tempo-tags)

(tempo-define-template "c-for-i"
		       '(> "for(" (p "variable: " var) " = 0; " (s var)
			   " < "(p "upper bound: " ub)"; " (s var) "++)" >  n>
			   "{" > n> r n
			   "} /* end of for(" (s var) " = 0; "
			   (s var) " < " (s ub) "; " (s var) "++) */" > n>
			   )
		       "fori"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-main"
		       '(> "main(int argc, char *argv[])" >  n>
			   "{" > n> r n n>
			   "return 0;" n
			   "} /* end of main() */" > n>
			   )
		       "main"
		       "Insert a C main statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-malloc"
		       '(> "if((" (p "variable: " var) " = ("
			   (p "type: " type) " *) malloc(sizeof(" (s type)
			   "))) == (" (s type) " *) NULL)" n>
			   "{" > n> r n
			   "} /* end of if((" (s var) " = (" (s type)
			   " *) malloc...) == NULL) */" > n>
			   )
		       "ifmalloc"
		       "Insert a C if(malloc...) statement"
		       'c-tempo-tags)

(tempo-define-template "c-switch"
		       '(> "switch(" (p "switch-condition: " clause) ")" >  n>
			   "{" > n
			   "case " (p "first value: ") ":" > n> p n
			   "break;" > n> p n
			   "default:" > n> p n
			   "break;" > n
			   "} /* end of switch(" (s clause) ") */" > n>
			   )
		       "switch"
		       "Insert a C switch statement"
		       'c-tempo-tags)

(tempo-define-template "c-case"
		       '(n "case " (p "value: ") ":" > n> p n
			   "break;" > n> p
			   )
		       "case"
		       "Insert a C case statement"
		       'c-tempo-tags)

(tempo-define-template "c-defun"
		       '((p "function name: " funcname)
			 "(" (p "arguments: " funcargs) ") {" n
			 > r n
			 (p "overload description: " overloaddesc t)
			 "}\t/* " (s funcname) "(" (s overloaddesc) ") */" > n
			 p)
		       "defun"
		       "Insert a c/c++ function definition. "
		       'c-tempo-tags)

;;;C++-Mode Templates

(tempo-define-template "c++-class"
		       '("class " (p "classname: " class) " {" n
			 "public:" n>
			 (s class) "();"
			 (progn (indent-for-comment) nil)
			 "the default constructor" n>
			 "virtual ~" (s class) "();"
			 (progn (indent-for-comment) nil)
			 "the destructor" n>
			 "// the default address-of operators" n>
			 "// " (s class) "* operator&() { return this; }" n>
			 "// const " (s class) "* operator&() const { return this; }" n
			 n> p n
			 "protected:" n> p n
			 "private:" n>
			 (s class) "(const " (s class) "&rhs);"
			 (progn (indent-for-comment) nil)
			 "the copy construtctor" n>
			 (s class) "& operator=(const " (s class) "&rhs);"
			 (progn (indent-for-comment) nil)
			 "the assignment operator" n>
			 p n
		         "};\t// end of class " (s class) n>
			 )
		       "class"
		       "Insert a class skeleton"
		       'c++-tempo-tags)

(require 'tempo-snippets)
(global-set-key (kbd "C-+") 'tempo-snippets-complete-tag)
