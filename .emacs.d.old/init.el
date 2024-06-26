(defun transparency (value)
  "Set the transparency"
  (interactive "nTrancparency Value 0 - 100 opaque: ")
  (set-frame-parameter (selected-frame) 'alpha value))

(transparency 100)


;; transparency on in terminal
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

;;(add-hook 'window-setup-hook 'on-after-init)

;;(setq inhibit-startup-message t) ;disable default emacs startpage
(scroll-bar-mode -1)    ; disable the visual scrollbar
(tool-bar-mode -1)      ;disable toolbar
(tooltip-mode -1)       ;disable tooltips
(set-fringe-mode 10)    ;stuff
(menu-bar-mode -1)      ;disable menu bar

(setq visible-bell t)

(set-face-attribute 'default nil :font "FiraCode Nerd Font Mono" :height 110)

(column-number-mode)
(global-display-line-numbers-mode t)

  ;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda() (display-line-numbers-mode 0))))

(require 'package)

;; package sources
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package counsel
  :diminish ivy-mode
  :bind (
	 ("C-s" . swiper)
	 ("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom (
           (doom-modeline-height 30)
           (doom-modeline-bar-width 6)
           (doom-modeline-lsp t)
           (doom-modeline-github nil)
           (doom-modeline-mu4e nil)
           (doom-modeline-irc t)
           (doom-modeline-minor-modes nil)
           (doom-modeline-persp-name nil)
           (doom-modeline-buffer-file-name-style 'truncate-except-project)
           (doom-modeline-major-mode-icon nil)))

(use-package nyan-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; doom-tomorrow-night is also pretty good
(use-package doom-themes
  :init (load-theme 'doom-tokyo-night t))

(defun switchorgtheme ()
  (load-theme 'spacemacs-light t))

(use-package spacemacs-theme)

;; (add-hook 'org-mode-hook 'switchorgtheme)

;; M-x all-the-icons-install-fonts
(use-package all-the-icons)

(use-package general)

(defconst custom-leader "C-c c")
(general-create-definer custom-leader-def :prefix custom-leader)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
   :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (lsp-rust-analyzer-cargo-watch-command "check")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.1)
  (lsp-inlay-hint-enable t)

  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (lsp-enable-which-key-integration t))

;; ivy integration
; (use-package lsp-ivy)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  ; (lsp-ui-sideline-show-hover t)
  (lsp-ui-side-line-enable t)
  (lsp-ui-doc-enable t))

(defun fem/org-mode-setup ()
      (load-theme 'doom-feather-light)
      (org-indent-mode)
      (variable-pitch-mode 1)
      (visual-line-mode 1))


    (defun fem/org-font-setup ()
      ;; Replace list hyphen with dot
      (font-lock-add-keywords 'org-mode
                              '(("^ *\\([-]\\) "
                                 (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

      ;; Set faces for heading levels
      (dolist (face '((org-level-1 . 1.1)
                      (org-level-2 . 1.1)
                      (org-level-3 . 1.05)
                      (org-level-4 . 1.0)
                      (org-level-5 . 1.1)
                      (org-level-6 . 1.1)
                      (org-level-7 . 1.1)
                      (org-level-8 . 1.1)))
        (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

      ;; Ensure that anything that should be fixed-pitch in Org files appears that way
      (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
      (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
      (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
      (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

    (use-package org
      :hook
      (org-mode . fem/org-mode-setup)
      :config
      (setq org-ellipsis " ▾"
            org-hide-emphasis-markers t
            org-hide-leading-stars t)
            ;org-agenda-files '("~/Project"))
      (fem/org-font-setup))

    ;; (use-package org-bullets
    ;;   :after org
    ;;   :hook (org-mode . org-bullets-mode)
    ;;   :custom
    ;;   (org-adapt-indentation t)
    ;;   (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(setq org-format-latex-options '(:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
             ("begin" "$1" "$" "$$" "\\(" "\\[")))



  (use-package org-superstar
    :hook (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-headline-bullets-list
          '("⇒" "◈" "○" "▷")))

  (org-babel-do-load-languages
    'org-babel-load-languages
    '((emacs-lisp . t)
      (python . t)
      (haskell . t)))

  (push '("conf-unix" . conf-unix) org-src-lang-modes)

  (with-eval-after-load 'org
    ;; This is needed as of Org 9.2
    (require 'org-tempo)

    (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
    (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
    (add-to-list 'org-structure-template-alist '("py" . "src python"))
    (add-to-list 'org-structure-template-alist '("src" . "src")))

(use-package org-roam
  :custom
  (org-roam-directory "~/Documents/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100)
  (setq visual-fill-column-center-text t)
  (message "visual thing enabled")
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e14884c30d875c64f6a9cdd68fe87ef94385550cab4890182197b95d53a7cf40" "7e377879cbd60c66b88e51fad480b3ab18d60847f31c435f15f5df18bdb18184" "e1f4f0158cd5a01a9d96f1f7cdcca8d6724d7d33267623cc433fe1c196848554" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "f5f80dd6588e59cfc3ce2f11568ff8296717a938edd448a947f9823a4e282b66" "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" default))
 '(package-selected-packages
   '(company-box lsp-ivy nyan-mode magit counsel-projectile hydra general all-the-icons doom-themes helpful ivy-rich rainbow-delimiters which-key visual-fill-column visual-fill undo-tree rust-mode projectile org-bullets neotree lsp-mode kaolin-themes kanagawa-theme flycheck doom-modeline dashboard counsel company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package page-break-lines)

(use-package dashboard
  :config
  (setq dashboard-banner-logo-title "Welcome to Femboy Emacs"
        dashboard-startup-banner 'official
        dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-icon-type 'all-the-icons
        dashboard-set-heading-icons t
        dashbaord-set-file-icons t
        dashboard-startupify-list '(dashboard-insert-banner
                                    dashboard-insert-newline
                                    dashboard-insert-banner-title
                                    dashboard-insert-newline
                                    dashboard-insert-navigator
                                    dashboard-insert-newline
                                    dashboard-insert-init-info
                                    dashboard-insert-items
                                    dashboard-insert-newline
                                    dashboard-insert-footer)
        dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)
                          (agenda    . 5)
                          (registers . 5))
        dashboard-heading-icons '((recents   . "history")
                                  (bookmarks . "bookmark")
                                  (agenda    . "calendar")
                                  (projects  . "rocket")
                                  (registers . "database")))
  (dashboard-setup-startup-hook))

(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package rustic
  :bind (:map rust-mode-map
              ("M-j" . lsp-ui-imenu)
          ("M-?" . lsp-find-references)
          ("C-c C-c l" . flycheck-list-errors)
          ("C-c C-c a" . lsp-execute-code-action)
          ("C-c C-c r" . lsp-rename)
          ("C-c C-c q" . lsp-workspace-restart)
          ("C-c C-c Q" . lsp-workspace-shutdown)
          ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
    ;; uncomment for less flashiness
  ;; (setq lsp-eldoc-hook nil)
  ;; (setq lsp-enable-symbol-highlighting nil)
  ;; (setq lsp-signature-auto-activate nil)

    ;; comment to disable rustfmt on save
  ;;(setq rustic-format-on-save t))
  )

(use-package flycheck)

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))

(custom-leader-def
 "c" 'compile
 "b" 'counsel-find-file)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
