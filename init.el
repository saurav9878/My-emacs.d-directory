
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(column-number-mode t)
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes
   (quote
    ("ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" default)))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(load-theme (quote wheatgrass) t)
 '(package-selected-packages
   (quote
    (ipython cmake-ide duplicate-thing clang-format company-quickhelp company-auctex company-irony-c-headers company-rtags company-irony irony flycheck-rtags flycheck-pyflakes flycheck emms markdown-mode+ org ac-clang company dracula-theme auctex auctex-latexmk helm-ctest helm-ls-git pdf-tools magit helm elpy atom-dark-theme)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))

;; completion of custom-set-variables

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; package repositories
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ;; ("melpa" . "https://melpa.org/packages/")
			 ("melpa_mb" . "http://melpa.milkbox.net/packages/")
			 ("org" . "http://orgmode.org/elpa/")))

;; default character encoding
(prefer-coding-system 'utf-8)

;; elpy
(require 'package)
(package-initialize)
(elpy-enable)

;; My Shortcuts
(global-set-key (kbd "C-c C-x c") 'comment-region)
(global-set-key (kbd "C-c C-x u") 'uncomment-region)
(global-set-key (kbd "M-s M-s") 'shell-script-mode)
(global-set-key (kbd "M-s RET") 'ansi-term)
(global-set-key (kbd "C-x t") 'transpose-frame)
(global-set-key (kbd "C-x c") 'compile)
(global-set-key (kbd "C-x p") (kbd "C-u -1 C-x o"))
(global-set-key (kbd "C-c C-x k") 'kill-emacs)

(define-key emacs-lisp-mode-map (kbd "C-c C-e") 'eval-region)
(define-key emacs-lisp-mode-map (kbd "C-c C-b") 'eval-buffer)

;; helm
(require 'helm-config)
(require 'helm)
(require 'helm-ls-git)
(require 'helm-ctest)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c t") 'helm-ctest)
(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
(setq
 helm-split-window-in-side-p           t
   ; open helm buffer inside current window,
   ; not occupy whole other window
 helm-move-to-line-cycle-in-source     t
   ; move to end or beginning of source when
   ; reaching top or bottom of source.
 helm-ff-search-library-in-sexp        t
   ; search for library in `require' and `declare-function' sexp.
 helm-scroll-amount                    8
   ; scroll 8 lines other window using M-<next>/M-<prior>
 helm-ff-file-name-history-use-recentf t
 ;; Allow fuzzy matches in helm semantic
 helm-semantic-fuzzy-match             t
 helm-imenu-fuzzy-match                t
 helm-echo-input-in-header-line        t )

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
		   (let ((bg-color (face-background 'default nil)))
		     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))

(add-hook 'helm-minibuffer-set-up-hook
	  'spacemacs//helm-hide-minibuffer-maybe)

;; Have helm automaticaly resize the window
(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)

;; AucTeX
(require 'tex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(require 'tex-fold)
(add-hook 'TeX-mode-hook
	  (lambda ()
	    (TeX-fold-mode 1)
	    (add-hook 'find-file-hook 'TeX-fold-buffer t t)
	    (add-hook 'after-change-functions
		      (lambda (start end oldlen)
			(when (= (- end start) 1)
			  (let ((char-point
				 (buffer-substring-no-properties
				  start end)))
			    (when (or (string= char-point "}")
			    	      (string= char-point "$"))
			      (TeX-fold-paragraph))
			    )))
		      t t)))
(add-hook 'TeX-mode-hook #'auto-fill-mode)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

;; latexmk support for auctex
(require 'auctex-latexmk)
(auctex-latexmk-setup)

;; pdf-tools
(pdf-tools-install)

;; pdf-info-synctex-forward-search
;; Use pdf-tools to open PDF files
(setq TeX-view-program-selection '((output-pdf "PDF Tools")) TeX-source-correlate-start-server t)

;; Update PDF buffers after successful LaTeX runs
(add-hook 'TeX-after-TeX-LaTeX-command-finished-hook #'TeX-revert-document-buffer)

(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
(add-hook 'TeX-mode 'pdf-sync-minor-mode)
(define-key TeX-mode-map (kbd "C-c M-v") 'pdf-sync-display-pdf)
(define-key TeX-mode-map (kbd "C-c v") 'pdf-sync-forward-search)

(add-hook 'TeX-mode 'auto-fill-mode)

;; Reftex
(add-hook 'LaTeX-mode-hook 'reftex-mode)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))

;; Org-Mode
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-co" 'org-indent-mode)
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-log-done 'time)
(setq org-log-done 'note)

;; ;; emacs init file
;; (find-file "~/.emacs.d/init.el")
(require 'preview)

;; emms
(require 'emms-setup)
(emms-all)
(emms-default-players)

;; y-or-n instead of yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; flycheck
(require 'flycheck)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c-mode-hook 'flycheck-mode)
(global-flycheck-mode t)
;; (require 'flycheck-pyflakes)
(require 'helm-flycheck) ;; Not necessary if using ELPA package
(eval-after-load 'flycheck
  '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck))

(require 'flycheck-rtags)
(defun my-flycheck-rtags-setup ()
  "Configure flycheck-rtags for better experience."
  (flycheck-select-checker 'rtags)
  (setq-local flycheck-check-syntax-automatically nil)
  (setq-local flycheck-highlighting-mode nil))
;; c-mode-common-hook is also called by c++-mode
(add-hook 'c-mode-common-hook #'my-flycheck-rtags-setup)

;; irony-mode
(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(defun my-irony-mode-hook ()
  "."
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

;; yasnippet
(require 'yasnippet)
;;(add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet-snippets/")
(yas-global-mode 1)
(yas-reload-all)

;; company-irony completion
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(require 'company-rtags)

(add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)

;; (setq company-backends (delete 'company-semantic
;; 			       company-backends))
(require 'company-irony-c-headers)
(eval-after-load 'company
  '(add-to-list
    'company-backends '(company-irony-c-headers company-irony)))
;; tab-completion with no delay
(setq company-idle-delay 0)
(define-key c-mode-map [C-tab] 'company-complete)
(define-key c++-mode-map [C-tab] 'company-complete)

(eval-after-load 'company
  '(progn
     (define-key company-mode-map (kbd "C-:") 'helm-company)
     (define-key company-active-map (kbd "C-:") 'helm-company)))
(define-key company-active-map (kbd "C-n") (lambda () (interactive) (company-complete-common-or-cycle 1)))
(define-key company-active-map (kbd "C-p") (lambda () (interactive) (company-complete-common-or-cycle -1)))

(defvar company-mode/enable-yas t
  "Enable yasnippet for all backends.")

(defun company-mode/backend-with-yas (backend)
  (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))
(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

;; company-auctex
(company-auctex-init)

;; company-quickhelp
(require 'company-quickhelp)
(company-quickhelp-mode 1)

;; clang-format
(require 'clang-format)
(global-set-key (kbd "C-M-TAB") 'clang-format-region)

;; Flyspell-mode
(require 'flyspell)

(setq flyspell-issue-welcome-flag nil)
(define-key flyspell-mode-map (kbd "<f8>") 'helm-flyspell-correct)
(global-set-key (kbd "C-S-<f8>") 'flyspell-mode)
(global-set-key (kbd "C-M-<f8>") 'flyspell-buffer)
(global-set-key (kbd "C-<f8>") 'flyspell-check-previous-highlighted-word)
(global-set-key (kbd "M-<f8>") 'flyspell-check-next-highlighted-word)
(defun flyspell-check-next-highlighted-word ()
  "Custom function to spell check next highlighted word."
  (interactive)
  (flyspell-goto-next-error)
  (ispell-word))
;; (add-hook 'c++-mode-hook  'flyspell-prog-mode)
;; (add-hook 'c-mode-common-hook 'flyspell-prog-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;; (if (fboundp 'prog-mode)
;;     (add-hook 'prog-mode-hook 'flyspell-prog-mode)
;;   (dolist (hook '(lisp-mode-hook emacs-lisp-mode-hook scheme-mode-hook
;; 				 clojure-mode-hook ruby-mode-hook yaml-mode
;; 				 python-mode-hook shell-mode-hook php-mode-hook
;; 				 css-mode-hook haskell-mode-hook caml-mode-hook
;; 				 nxml-mode-hook crontab-mode-hook perl-mode-hook
;; 				 tcl-mode-hook javascript-mode-hook))
;;     (add-hook hook 'flyspell-prog-mode)))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))

;; ;; MAGIT
;; (require 'magit)
;; (global-set-key (kbd "M-g M-s") 'magit-status)
;; (global-set-key (kbd "M-g M-c") 'magit-checkout)

;; duplicate-thing
(require 'duplicate-thing)
(global-set-key (kbd "M-c") 'duplicate-thing)

;; Setup cmake-ide
;; (load "~/.emacs.d/cmake-ide")
(require 'cmake-ide)
(cmake-ide-setup)
(setq cmake-ide-flags-c++ (append '("std-c++11")))
(global-set-key (kbd "C-c m") 'cmake-ide-compile)

(defun maybe-cmake-project-hook ()
  "Enable cmake project mode if CMakeLists.txt exists."
  (if (file-exists-p "CMakeLists.txt") (cmake-project-mode)))
(add-hook 'c-mode-hook 'maybe-cmake-project-hook)
(add-hook 'c++-mode-hook 'maybe-cmake-project-hook)

(setq yas-snippet-dirs "~/.emacs.d/plugins/yasnippet/")


;; ;; function-args
;; (require 'function-args)
;; (fa-config-default)
;; (define-key c-mode-map  [(tab)] 'company-complete)
;; (define-key c++-mode-map  [(tab)] 'company-complete)


;; ;; sr-speedbar
;; (require 'sr-speedbar)
;; (global-set-key (kbd "C-c s") 'sr-speedbar-toggle)

;; autoclose braces
(electric-pair-mode t)

;; Octave mode
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook
          (lambda ()
            (abbrev-mode 1)
            (auto-fill-mode 1)
            (if (eq window-system 'x)
                (font-lock-mode 1))))

;;; init.el ends here
