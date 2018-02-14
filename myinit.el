(setq inhibit-startup-message t)  ; hide the startup screen
(tool-bar-mode -1)  ; -1 to hide the toolbar to give us more space
(fset 'yes-or-no-p 'y-or-n-p)  ; type y or n instead of yes or no
(global-linum-mode t)  ; enable line numbers globally; (global-flycheck-mode t); ; enable flycheck globally
(add-hook 'before-save-hook 'delete-trailing-whitespace)  ; remove trailing space when saving
(exec-path-from-shell-copy-env "PATH") ; let $PATH variable be read by Emacs, we may also need to install exec-path-from-shell package

;; The comment out is used heavily, we do it in a more handy way
;; default: M-;
;; now: C-; , C-;
;; (global-set-key (kbd "C-;") 'comment-dwim)

;; reload a file into current buffer using the F5
(global-set-key (kbd "<f5>") 'revert-buffer)

;; set ctrl+z to do nothing because it is so easy to paralyze emacs
;; default:
;; now: nothing
(global-unset-key (kbd "C-z"))

(use-package try
  :ensure t)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(defun my/org-mode-hook ()
  "Stop the org-level headers from increasing in height relative to the other text."
  (dolist (face '(org-level-1
                  org-level-2
                  org-level-3
                  org-level-4
                  org-level-5))
    (set-face-attribute face nil :weight 'semi-bold :height 1.0)))

(add-hook 'org-mode-hook 'my/org-mode-hook)

;; (use-package zenburn-theme
;;   : ensure t
;;   : config (load-theme 'zenburn t))

;; (use-package solarized-theme
;;   : ensure t
;;   : config
;;   (load-theme 'solarized-light t)
;;   (setq solarized-high-contrast-mode-line t))

;; counsel and swiper together give us a more powerful search for keyword and file
;; (use-package color-theme-sanityinc-tomorrow
;;   :ensure t
;;   :config
;;   (load-theme 'sanityinc-tomorrow-bright t))

(use-package material-theme
  :ensure t
  :config
  (load-theme 'material t))

(use-package ace-window
  :ensure t
  :init
  (progn
    (setq aw-scope 'frame)
    (global-set-key (kbd "C-x O") 'other-frame)
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))
    ))

(use-package counsel
  :ensure t
  :bind
  (("M-y" . counsel-yank-pop)
  :map ivy-minibuffer-map
   ("M-y" . ivy-next-line)))

(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))


(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)
	 ("C-r" . swiper)
	 ("C-c C-r" . ivy-resume)
	 ("M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file))
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq ivy-display-style 'fancy)
    (define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
    ))

(use-package avy  ; allowing search and go to a single character
  :ensure t
  :init
  (progn  ; progn is used when mutilple lines of code need executing;;
  ;; (avy-setup-default) ; comment out for more function once familiar with avy
  )
  :bind
  ("M-s" . avy-goto-word-1)) ;; changed from char as per jcs

(use-package auto-complete
:ensure t
:init
(progn
  (ac-config-default)
  (global-auto-complete-mode t)
  (global-flycheck-mode t)  ;; enable flycheck globally
  ))

;; BASIC CUSTOMIZATION
;; --------------------------------------
;; use ido mode which is a nicer buffer selcetion (comment out since we use swiper instead)
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)

;; (defalias 'list-buffers 'ibuffer) ; make ibuffer default
;; (defalias 'list-buffers 'ibuffer-other-window); make ibuffer default and use aother window;

;; window related
;; inbuffer-navigation
;; (defalias 'list-buffers 'ibuffer) ; make ibuffer default
;; (defalias 'list-buffers 'ibuffer-other-window); make ibuffer default and use aother window

;; Get the nice looking bullets
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setenv "BROWSER" "firefox")

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(custom-set-variables
 '(org-directory "~/orgNote/orgfiles")
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-startup-folded (quote overview))
 '(org-startup-indented t)
 )

(setq org-file-apps
      (append '(
                ("\\.pdf\\'" . "evince %s")
                ) org-file-apps ))

(global-set-key "\C-ca" 'org-agenda)

(setq org-agenda-custom-commands
      '(("c" "Simple agenda view"
         ((agenda "")
          (alltodo "")))))

(use-package org-ac
  :ensure t
  :init (progn
          (require 'org-ac)
          (org-ac/config-default)
          ))

(global-set-key (kbd "C-c c") 'org-capture)

(setq org-agenda-files (list "~/orgNotes/orgfiles/gcal.org"
                             "~/orgNotes/orgfiles/i.org"
                             "~/orgNotes/orgfiles/schedule.org"))
(setq org-capture-templates
      '(("a" "Appointment" entry (file  "~/orgNotes/orgfiles/gcal.org" )
         "* %?\n\n%^T\n\n:PROPERTIES:\n\n:END:\n\n")
        ("l" "Link" entry (file+headline "~/orgNotes/orgfiles/links.org" "Links")
         "* %? %^L %^g \n%T" :prepend t)
        ("b" "Blog idea" entry (file+headline "~/orgNotes/orgfiles/i.org" "Blog Topics:")
         "* %?\n%T" :prepend t)
        ("t" "To Do Item" entry (file+headline "~/orgNotes/orgfiles/i.org" "To Do")
         "* TODO %?\n%u" :prepend t)
        ("m" "Mail To Do" entry (file+headline "~/orgNotes/orgfiles/i.org" "To Do")
         "* TODO %a\n %?" :prepend t)
        ("g" "GMail To Do" entry (file+headline "~/orgNotes/orgfiles/i.org" "To Do")
         "* TODO %^L\n %?" :prepend t)
        ("n" "Note" entry (file+headline "~/orgNotes/orgfiles/i.org" "Note space")
         "* %?\n%u" :prepend t)
        ("s" "Code Snippet" entry (file+headline "~/orgNotes/orgfiles/i.org" "Code Snippet")
         "* %?\n#+BEGIN_SRC %^{language}\n\n#+END_SRC" :prepend nil)
        ))

    ;; (setq org-capture-templates
    ;; 		    '(("a" "Appointment" entry (file  "~/orgNotes/orgfiles/gcal.org" )
    ;; 			     "* TODO %?\n:PROPERTIES:\nDEADLINE: %^T \n\n:END:\n %i\n")
    ;; 			    ("l" "Link" entry (file+headline "~/orgNotes/orgfiles/links.org" "Links")
    ;; 			     "* %? %^L %^g \n%T" :prepend t)
    ;; 			    ("b" "Blog idea" entry (file+headline "~/orgNotes/orgfiles/i.org" "Blog Topics:")
    ;; 			     "* %?\n%T" :prepend t)
    ;; 			    ("t" "To Do Item" entry (file+headline "~/orgNotes/orgfiles/i.org" "To Do")
    ;; 			     "* TODO %?\n%u" :prepend t)
    ;; 			    ("n" "Note" entry (file+headline "~/orgNotes/orgfiles/i.org" "Note space")
    ;; 			     "* %?\n%u" :prepend t)

    ;; 			    ("j" "Journal" entry (file+datetree "~/orgNotes/journal.org")
    ;; 			     "* %?\nEntered on %U\n  %i\n  %a")
    ;;                                ("s" "Screencast" entry (file "~/orgNotes/orgfiles/screencastnotes.org")
    ;;                                "* %?\n%i\n")))


(defadvice org-capture-finalize
    (after delete-capture-frame activate)
  "Advise capture-finalize to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(defadvice org-capture-destroy
    (after delete-capture-frame activate)
  "Advise capture-destroy to close the frame"
  (if (equal "capture" (frame-parameter nil 'name))
      (delete-frame)))

(use-package noflet
  :ensure t )
(defun make-capture-frame ()
  "Create a new frame and run org-capture."
  (interactive)
  (make-frame '((name . "capture")))
  (select-frame-by-name "capture")
  (delete-other-windows)
  (noflet ((switch-to-buffer-other-window (buf) (switch-to-buffer buf)))
    (org-capture)))

(require 'ox-beamer)

(use-package ox-reveal
  :ensure ox-reveal)

(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
(setq org-reveal-mathjax t)  ;  LaTeX equations will look nice

(use-package htmlize  ; syntax highlighting
  :ensure t)

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t)
  ;; use flycheck not flymake with elpy
  ;; (when (require 'flycheck nil t)
  ;;   (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  ;;   (add-hook 'elpy-mode-hook 'flycheck-mode))
  )

(use-package yasnippet
  :ensure t
  :init
    (yas-global-mode 1))

(use-package better-shell
    :ensure t
    :bind (("C-'" . better-shell-shell)
           ;("C-;" . better-shell-remote-open)
           ))

(use-package shell-switcher
    :ensure t
    :config
    (setq shell-switcher-mode t)
    :bind (("C-'" . shell-switcher-switch-buffer)
           ("C-x 4 '" . shell-switcher-switch-buffer-other-window)
           ("C-M-'" . shell-switcher-new-shell)))


  ;; Visual commands
  (setq eshell-visual-commands '("vi" "screen" "top" "less" "more" "lynx"
                                 "ncftp" "pine" "tin" "trn" "elm" "vim"
                                 "nmtui" "alsamixer" "htop" "el" "elinks"
                                 ))
  (setq eshell-visual-subcommands '(("git" "log" "diff" "show")))
  (setq eshell-list-files-after-cd t)
  (defun eshell-clear-buffer ()
    "Clear terminal"
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)
      (eshell-send-input)))
  (add-hook 'eshell-mode-hook
            '(lambda()
               (local-set-key (kbd "C-l") 'eshell-clear-buffer)))

  (defun eshell/magit ()
    "Function to open magit-status for the current directory"
    (interactive)
    (magit-status default-directory)
    nil)

 ;; smart display stuff
(require 'eshell)
(require 'em-smart)
(setq eshell-where-to-jump 'begin)
(setq eshell-review-quick-commands nil)
(setq eshell-smart-space-goes-to-end t)

(add-hook 'eshell-mode-hook
  (lambda ()
    (eshell-smart-initialize)))
;; eshell here
(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
current buffer's file. The eshell is renamed to match that
directory to make multiple eshell windows easier."
  (interactive)
  (let* ((parent (if (buffer-file-name)
                     (file-name-directory (buffer-file-name))
                   default-directory))
         (height (/ (window-total-height) 3))
         (name   (car (last (split-string parent "/" t)))))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (rename-buffer (concat "*eshell: " name "*"))

    (insert (concat "ls"))
    (eshell-send-input)))

(global-set-key (kbd "C-!") 'eshell-here)

(defcustom dotemacs-eshell/prompt-git-info
  t
  "Turns on additional git information in the prompt."
  :group 'dotemacs-eshell
  :type 'boolean)

;; (epe-colorize-with-face "abc" 'font-lock-comment-face)
(defmacro epe-colorize-with-face (str face)
  `(propertize ,str 'face ,face))

(defface epe-venv-face
  '((t (:inherit font-lock-comment-face)))
  "Face of python virtual environment info in prompt."
  :group 'epe)

  (setq eshell-prompt-function
      (lambda ()
        (concat (propertize (abbreviate-file-name (eshell/pwd)) 'face 'eshell-prompt)
                (when (and dotemacs-eshell/prompt-git-info
                           (fboundp #'vc-git-branches))
                  (let ((branch (car (vc-git-branches))))
                    (when branch
                      (concat
                       (propertize " [" 'face 'font-lock-keyword-face)
                       (propertize branch 'face 'font-lock-function-name-face)
                       (let* ((status (shell-command-to-string "git status --porcelain"))
                              (parts (split-string status "\n" t " "))
                              (states (mapcar #'string-to-char parts))
                              (added (count-if (lambda (char) (= char ?A)) states))
                              (modified (count-if (lambda (char) (= char ?M)) states))
                              (deleted (count-if (lambda (char) (= char ?D)) states)))
                         (when (> (+ added modified deleted) 0)
                           (propertize (format " +%d ~%d -%d" added modified deleted) 'face 'font-lock-comment-face)))
                       (propertize "]" 'face 'font-lock-keyword-face)))))
                (when (and (boundp #'venv-current-name) venv-current-name)
                  (concat
                    (epe-colorize-with-face " [" 'epe-venv-face)
                    (propertize venv-current-name 'face `(:foreground "#2E8B57" :slant italic))
                    (epe-colorize-with-face "]" 'epe-venv-face)))
                (propertize " $ " 'face 'font-lock-constant-face))))

; Highlights the current cursor line
(global-hl-line-mode t)

; flashes the cursor's line when you scroll
(use-package beacon
:ensure t
:config
(beacon-mode 1)
 (setq beacon-color "#666600")
)

; deletes all the whitespace when you hit backspace or delete
(use-package hungry-delete
:ensure t
:config
(global-hungry-delete-mode))

; expand the marked region in semantic increments (negative prefix to reduce region)
(use-package expand-region
:ensure t
:config
(global-set-key (kbd "C-=") 'er/expand-region))

;; use C-h v to see the description of save-interprogram-paste-before-kill
(setq save-interprogram-paste-before-kill t)

;; revert will refresh the file content shown in emacs
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f6>") 'revert-buffer)

; mark and edit all copies of the marked region simultaniously.
(use-package iedit
  :ensure t)

; if you're windened, narrow to the region, if you're narrowed, widen
; bound to C-x n
(defun narrow-or-widen-dwim (p)
"If the buffer is narrowed, it widens. Otherwise, it narrows intelligently.
Intelligently means: region, org-src-block, org-subtree, or defun,
whichever applies first.
Narrowing to org-src-block actually calls `org-edit-src-code'.

With prefix P, don't widen, just narrow even if buffer is already
narrowed."
(interactive "P")
(declare (interactive-only))
(cond ((and (buffer-narrowed-p) (not p)) (widen))
((region-active-p)
(narrow-to-region (region-beginning) (region-end)))
((derived-mode-p 'org-mode)
;; `org-edit-src-code' is not a real narrowing command.
;; Remove this first conditional if you don't want it.
(cond ((ignore-errors (org-edit-src-code))
(delete-other-windows))
((org-at-block-p)
(org-narrow-to-block))
(t (org-narrow-to-subtree))))
(t (narrow-to-defun))))

;; (define-key endless/toggle-map "n" #'narrow-or-widen-dwim)
;; This line actually replaces Emacs' entire narrowing keymap, that's
;; how much I like this command. Only copy it if that's what you want.
(define-key ctl-x-map "n" #'narrow-or-widen-dwim)

(use-package web-mode
    :ensure t
    :config
         (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
         (setq web-mode-engines-alist
               '(("django"    . "\\.html\\'")))
         (setq web-mode-ac-sources-alist
               '(("css" . (ac-source-css-property))
                 ("html" . (ac-source-words-in-buffer ac-source-abbrev))))

(setq web-mode-enable-auto-closing t)
(setq web-mode-enable-auto-quoting t))

(use-package ggtags
:ensure t
:config
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
)

(setq py-python-command "python3")
(setq python-shell-interpreter "python3")

(use-package jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook 'jedi:setup)
  (add-hook 'python-mode-hook 'jedi:ac-setup))

(use-package elpy
  :ensure t
  :config
  (elpy-enable))

(use-package virtualenvwrapper
  :ensure t
  :config
  (venv-initialize-interactive-shells)
  (venv-initialize-eshell))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(use-package fsharp-mode
  :ensure t)
;; (unless (package-installed-p 'fsharp-mode)
;;   (package-install 'fsharp-mode))
;; (require 'fsharp-mode)

;; To make SLIME connect to your lisp whenever you open a lisp file
;; Install SLIME for Common Lisp
;; This has been well documented here: https://common-lisp.net/project/slime/doc/html
;; M-x package-install RET slime RET
;; after having the elisp code below, do a restart and everything is good

(use-package slime
  :ensure t
  :init
  ;; To make SLIME connect to your lisp whenever you open a lisp file
  (add-hook 'slime-mode-hook
      (lambda ()
	(unless (slime-connected-p)
	  (save-excursion (slime)))))
  (setq inferior-lisp-program "/usr/local/acl10.1express/alisp")
  (require 'slime-autoloads)
  ;; Set your lisp system and some contribs
  (setq slime-contribs '(slime-scratch slime-editing-commands))
  ;; REPL is a very essential contrib
  (setq slime-contribs '(slime-repl))  ; repl only
  ;; (setq slime-contribs '(slime-fancy))  ; slime-fancy is more fancy than REPL, containing almost everything
  )

;; (require 'slime-autoloads);; Set your lisp system and some contribs
;; To make SLIME connect to your lisp whenever you open a lisp file
;; (setq slime-contribs '(slime-repl)); repl only;; slime-fancy is more fancy than REPL
;; (setq slime-contribs '(slime-fancy)); almost everything

(add-to-list 'load-path "~/.emacs.d/elisp/pde/lisp")
(load "pde-load")
