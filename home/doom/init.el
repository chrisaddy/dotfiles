;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and in what order they
;; load. Remember to run 'doom sync' after modifying it!
;;
;; Press 'K' on a module to view its documentation, and 'gd' to browse its
;; source code.

(doom! :completion
       (vertico +icons)        ; the search engine of the future
       (corfu +icons +orderless)          ; complete with cap(f), cape and a flying feather!

       :ui
       doom                    ; what makes DOOM look the way it does
       doom-dashboard          ; a nifty splash screen for Emacs
       (emoji +unicode)        ; 🙂
       hl-todo                 ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       (ligatures +extra)      ; ligatures and symbols to make code pretty again
       modeline                ; snazzy, Atom-inspired modeline, plus API
       nav-flash               ; blink cursor line after big motions
       ophints                 ; highlight the region an operation acts on
       (popup +defaults)       ; tame sudden yet inevitable temporary windows
       smooth-scroll           ; So smooth you won't believe it's not butter
       tabs                    ; a tab bar for Emacs
       unicode                 ; extended unicode support for various languages
       (vc-gutter +pretty)     ; vcs diff in the fringe
       vi-tilde-fringe         ; fringe tildes to mark beyond EOB
       window-select           ; visually switch windows
       workspaces              ; tab emulation, persistence & separate workspaces

       :editor
       (evil +everywhere)      ; come to the dark side, we have cookies
       file-templates          ; auto-snippets for empty files
       fold                    ; (nigh) universal code folding
       (format +onsave)        ; automated prettiness
       snippets                ; my elves. They type so I don't have to
       (whitespace +guess +trim)  ; a butler for your whitespace

       :emacs
       (dired +icons)          ; making dired pretty [functional]
       electric                ; smarter, keyword-based electric-indent
       (ibuffer +icons)        ; interactive buffer management
       undo                    ; persistent, smarter undo for your inevitable mistakes
       vc                      ; version-control and Emacs, sitting in a tree

       :term
       vterm                   ; the best terminal emulation in Emacs

       :checkers
       syntax                  ; tasing you for every semicolon you forget

       :tools
       (eval +overlay)         ; run code, run (also, repls)
       lookup                  ; navigate your code and its documentation
       (lsp +peek)             ; M-x vscode
       magit                   ; a git porcelain for Emacs
       pdf                     ; pdf enhancements
       tree-sitter             ; syntax and parsing, sitting in a tree...

       :os
       (:if (featurep :system 'macos) macos)  ; improve compatibility with macOS

       :lang
       (cc +lsp)         ; C > C++ == 1
       common-lisp       ; if you've seen one lisp, you've seen them all
       elixir            ; erlang done right
       emacs-lisp              ; drown in parentheses
       ess               ; emacs speaks statistics
       (go +lsp)         ; the hipster dialect
       (haskell +lsp)    ; a language that's lazier than I am
       json              ; At least it ain't XML
       javascript        ; all(hope(abandon(ye(who(enter(here))))))
       latex             ; writing papers in Emacs has never been so fun
       (markdown +grip)        ; writing docs for people to ignore
       (nix)                   ; I hereby declare "nix geht mehr!"
       ocaml             ; an objective camel
       (org +pretty)           ; organize your plain life in plain text
       (python +lsp +pyright +tree-sitter)  ; beautiful is better than ugly
       (rust +lsp)       ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       (sh +lsp)               ; she sells {ba,z,fi}sh shells on the C xor
       yaml              ; JSON, but readable

       :config
       (default +bindings +smartparens))
