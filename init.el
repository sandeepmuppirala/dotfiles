;; Zoom
;;(set-face-attribute 'default nil :height 138)

;; Save History
(savehist-mode +1)
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))

(defun ar/show-welcome-buffer ()
  "Show *Welcome* buffer."
  (with-current-buffer (get-buffer-create "<3 EMACS <3")
    (setq truncate-lines t)
    (let* ((buffer-read-only)
           (image-path "/opt/code/emacs/startup-image/emacs.png")
           (image (create-image image-path))
           (size (image-size image))
           (height (cdr size))
           (width (car size))
           (top-margin (floor (/ (- (window-height) height) 1.3)))
           (left-margin (floor (/ (- (window-width) width) 1.3)))
           (prompt-title "SANDEEP MUPPIRALA's Emacs"))
      (erase-buffer)
      (setq mode-line-format nil)
      (goto-char (point-min))
      (insert (make-string top-margin ?\n ))
      (insert (make-string left-margin ?\ ))
      (insert-image image)
      (insert "\n\n\n")
      (insert (make-string (floor (/ (- (window-width) (string-width prompt-title)) 1.42)) ?\ ))
      (insert prompt-title))
    (setq cursor-type nil)
    (read-only-mode +1)
    (switch-to-buffer (current-buffer))
    (local-set-key (kbd "q") 'kill-this-buffer)))

(setq initial-scratch-message nil)
(setq inhibit-startup-screen t)

(when (< (length command-line-args) 2)
  (add-hook 'emacs-startup-hook (lambda ()
                                  (when (display-graphic-p)
                                    (ar/show-welcome-buffer)))))

;; Size of the starting Window
(setq initial-frame-alist '((top . 1)
			    (left . 1)
			    (width . 101)
			    (height . 70)))


;; Basic modes
(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(column-number-mode 1)
(global-visual-line-mode 1)
(delete-selection-mode 1)
(save-place-mode 1)
(global-display-line-numbers-mode 1)

;; Recent files
(recentf-mode 1)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(setq package-check-signature nil)

;; UTF-8
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)

;; Backups
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions -1)
(setq version-control t)
(setq vc-make-backup-files t)
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; Quickly access init.el
(global-set-key (kbd "C-c el")
		(lambda()
		  (interactive)
		  (find-file "~/.emacs.d/init.el")))

(setq case-fold-search t)

(setq sentence-end-double-space nil)

(global-goto-address-mode +1)

;; (load-theme 'modus-vivendi t)

(load-theme 'kaolin-aurora t)

;; (use-package ef-themes
;;   :config
;;   (load-theme 'ef-duo-dark t))
;;;;   (load-theme 'ef-maris-dark t))

;; (use-package gruvbox
;;   :config
;;   (load-theme 'gruvbox-dark-hard t)) 

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
;;(load-theme 'modus-vivendi t)

;; Company mode
(setq company-idle-delay 0)
(setq company-minimum-prefix-length 1)

(add-to-list 'load-path "/opt/code/emacs/go-mode.el")
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; Go - lsp-mode
;; Set up before-save hooks to format buffer and add/delete imports.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

(use-package go-tag
  :ensure t
)

(use-package godoctor
  :ensure t
  )

;; Dired config
(add-to-list 'load-path "/opt/code/emacs/dired-sidebar")
(require 'dired-sidebar)

(use-package dired-sidebar
  :bind (("<f8>" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-window-fixed nil)
  (setq dired-sidebar-use-term-integration t)
  (setq all-the-icons-dired-monochrome nil)
  (setq dired-sidebar-should-follow-file t))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons all-the-icons-dired company compile-multi
		   compile-multi-all-the-icons compile-multi-embark
		   compiler-explorer consult dired-sidebar
		   doom-modeline doom-themes dot-env eat ef-themes
		   fireplace go-tag godoctor gruvbox-theme
		   kaolin-themes key-quiz lsp-mode lsp-treemacs lsp-ui
		   magit marginalia meow nerd-icons orderless popper
		   rainbow-delimiters snow treemacs-icons-dired
		   vertico vscode-icon vterm vterm-toggle which-key
		   yasnippet)))

(defun open-terminal-in-workdir ()
    (let ((default-directory "/opt/code"))
      (vterm "VTerm /opt/code")))

(setq default-frame-alist '((font . "JetBrains Mono-13")))
   (add-to-list 'default-frame-alist '(line-spacing . 0.2))

(setq
 org-directory "/opt/"
 projectile-project-search-path '("/opt/code/"))

(use-package magit
  :ensure t)

(use-package all-the-icons
:ensure t)

(defun open-terminal-in-workdir ()
    (let ((default-directory "/opt/code"))
  (vterm "VTerm /opt/code")))

(display-time-mode 1)

(defface egoge-display-time
  '((((type x w32 mac))
     ;; #060525 is the background colour of my default face.
     (:foreground "#060525" :inherit bold))
    (((type tty))
     (:foreground "blue"))) "Face used to display the time in the mode line.")

 ;; This causes the current time in the mode line to be displayed in
 ;; `egoge-display-time-face' to make it stand out visually.
(setq display-time-string-forms
      '((propertize (concat " " 24-hours ":" minutes " ")
		    'face 'egoge-display-time)))


(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  (custom-set-faces
   '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "SeaGreen3"))))
   '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "HotPink1"))))
   '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "firebrick1"))))
   '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "medium orchid"))))
   '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "DeepPink1"))))
   '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "DarkGoldenrod1"))))
   '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "SteelBlue1"))))
   '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "orange red"))))
   '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "SlateBlue1"))))))

(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

(use-package consult
  :ensure t
  :bind (;; A recursive grep
         ("M-s M-g" . consult-grep)
         ;; Search for files names recursively
         ("M-s M-f" . consult-find)
         ;; Search through the outline (headings) of the file
         ("M-s M-o" . consult-outline)
         ;; Search the current buffer
         ("M-s M-l" . consult-line)
         ;; Switch to another buffer, or bookmarked file, or recently
         ;; opened file.
         ("M-s M-b" . consult-buffer)))

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; (defun meow-setup ()
;;   (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
;;   (meow-motion-overwrite-define-key
;;    '("j" . meow-next)
;;    '("k" . meow-prev)
;;    '("<escape>" . ignore))
;;   (meow-leader-define-key
;;    ;; SPC j/k will run the original command in MOTION state.
;;    '("j" . "H-j")
;;    '("k" . "H-k")
;;    '("." . "M-.")
;;    '("," . "M-,")
;;    '("ak" . "C-a k")
;;    '(";" . comment-line)
;;    '("?" . meow-cheatsheet))
;;   (meow-normal-define-key
;;    '("h" . meow-left)
;;    '("b" . meow-left)
;;    '("j" . meow-next)
;;    '("n" . meow-next)
;;    '("k" . meow-prev)
;;    '("p" . meow-prev)
;;    '("l" . meow-right)
;;    '("f" . meow-right)
;;    '("y" . meow-yank)
;;    '("q" . meow-quit)
;;    '("dd" . meow-kill)
;;    '("<escape>" . ignore)))

;; (use-package meow
;;   :custom
;;   (meow-use-cursor-position-hack t)
;;   (meow-use-clipboard t)
;;   (meow-goto-line-function 'consult-goto-line)
;;   :config
;;   ;; set colors in theme
;;   (setq meow-use-dynamic-face-color nil)
;;   ;; Make sure delete char means delete char
;;   (setq meow--kbd-delete-char "<deletechar>")
;;   (meow-thing-register 'angle '(regexp "<" ">") '(regexp "<" ">"))
;;   (add-to-list 'meow-char-thing-table '(?a . angle))
;;   ;; start vterm in insert
;;   (add-to-list 'meow-mode-state-list '(vterm-mode . insert))
;;   (meow-global-mode 1)
;;   (meow-setup))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(meow-insert-cursor ((t (:background "white")))) 
 '(rainbow-delimiters-depth-1-face ((t (:inherit rainbow-delimiters-base-face :foreground "SeaGreen3"))))
 '(rainbow-delimiters-depth-2-face ((t (:inherit rainbow-delimiters-base-face :foreground "HotPink1"))))
 '(rainbow-delimiters-depth-3-face ((t (:inherit rainbow-delimiters-base-face :foreground "firebrick1"))))
 '(rainbow-delimiters-depth-4-face ((t (:inherit rainbow-delimiters-base-face :foreground "medium orchid"))))
 '(rainbow-delimiters-depth-5-face ((t (:inherit rainbow-delimiters-base-face :foreground "DeepPink1"))))
 '(rainbow-delimiters-depth-6-face ((t (:inherit rainbow-delimiters-base-face :foreground "DarkGoldenrod1"))))
 '(rainbow-delimiters-depth-7-face ((t (:inherit rainbow-delimiters-base-face :foreground "SteelBlue1"))))
 '(rainbow-delimiters-depth-8-face ((t (:inherit rainbow-delimiters-base-face :foreground "orange red"))))
 '(rainbow-delimiters-depth-9-face ((t (:inherit rainbow-delimiters-base-face :foreground "SlateBlue1")))))
(setq meow-cursor-type-insert '(box . 1))

(use-package undo-fu
  :config
  (global-unset-key (kbd "C-z"))
  (global-set-key (kbd "C-z")   'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") 'undo-fu-only-redo))

(require 'popper)
;; Match eshell, shell, term and/or vterm buffers
(setq popper-reference-buffers
      (append popper-reference-buffers
              '("^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
		)))
(global-set-key (kbd "C-`") 'popper-toggle)  
(global-set-key (kbd "M-`") 'popper-cycle)
(global-set-key (kbd "C-M-`") 'popper-toggle-type)
(popper-mode +1)
;; For echo-area hints
(require 'popper-echo)
(popper-echo-mode +1)

(setq native-comp-async-report-warnings-errors 'silent)
