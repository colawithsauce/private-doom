;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "colawithsauce"
      user-mail-address "cola_with_sauce@foxmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq
 my-font-size 26
 ;; doom-font (font-spec :family "CaskaydiaCove Nerd Font Mono" :size my-font-size :weight 'semilight)
 ;; doom-font (font-spec :family "BlexMono Nerd Font Mono" :size my-font-size)
 doom-font (font-spec :family "Recursive Mono Casual Static" :size my-font-size)
 ;; doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size my-font-size :weight 'semilight)
 doom-variable-pitch-font (font-spec :family "BlexMono Nerd Font" :size my-font-size)
 doom-unicode-font (font-spec :family  "Twitter Color Emoji" :size my-font-size :weight 'semilight))

(defun my-cjk-font()
  (dolist (charset '(kana han cjk-misc symbol bopomofo))
    (set-fontset-font t charset (font-spec :family "LXGW WenKai Mono"))))

(add-hook! 'after-setting-font-hook #'my-cjk-font)
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; (add-to-list 'default-frame-alist '(alpha-background . 80))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Org/")


(setq url-gateway-local-host-regexp
      (concat "\\`" (regexp-opt '("localhost" "127.0.0.1")) "\\'"))
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
        ("http" . "127.0.0.1:7890")
        ("https" . "127.0.0.1:7890")))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (after! lsp-mode
;;   (map! :leader
;;         :desc "Diagnostics" "c-" #'lsp-ui-flycheck-list)
;;   (setq +lsp-company-backends
;;         (if (modulep! :editor snippets)
;;             '(:separate company-capf company-yasnippet :with company-tabnine)
;;           'company-capf)))
;; ;; Completion settings
;; (after! company
;;   (setq company-idle-delay 0.250
;;         company-minimum-prefix-length 1
;;         company-show-quick-access t))

(use-package org-protocol
  :config
  (add-to-list 'org-protocol-protocol-alist
               '("org-find-file" :protocol "find-file" :function org-protocol-find-file :kill-client nil))

  (defun org-protocol-find-file-fix-wsl-path (path)
    "If inside WSL, change Windows-style paths to WSL-style paths."
    (if (not (string-match-p "-[Mm]icrosoft" operating-system-release))
        path
      (save-match-data
        (if (/= 0 (string-match "^\\([a-zA-Z]\\):\\(/.*\\)" path))
            path
          (let ((volume (match-string-no-properties 1 path))
                (abspath (match-string-no-properties 2 path)))
            (format "/mnt/%s%s" (downcase volume) abspath))))))

  (defun org-protocol-find-file (fname)
    "Process org-protocol://find-file?path= style URL."
    (let ((f (plist-get (org-protocol-parse-parameters fname nil '(:path)) :path)))
      (find-file (org-protocol-find-file-fix-wsl-path f))
      (raise-frame)
      (select-frame-set-input-focus (selected-frame)))))

;; From https://github.com/hlissner/.doom.d
(map! (:after evil-org
       :map evil-org-mode-map
       :n "gk" (cmd! (if (org-on-heading-p)
                         (org-backward-element)
                       (evil-previous-visual-line)))
       :n "gj" (cmd! (if (org-on-heading-p)
                         (org-forward-element)
                       (evil-next-visual-line))))

      :o "o" #'evil-inner-symbol)

(map! (:after evil-markdown
       :map evil-markdown-mode-map
       :i "M-b" #'backward-word
       :n "gk" (cmd! (if (markdown-on-heading-p)
                         (markdown-backward-same-level)
                       (evil-previous-visual-line)))
       :n "gj" (cmd! (if (markdown-on-heading-p)
                         (markdown-forward-same-level)
                       (evil-next-visual-line)))))

(with-eval-after-load 'org-roam
  (setq org-roam-capture-templates
        '(("d" "default" plain "%?" :target
           (file+head "${slug}.org" "#+title: ${title}\n")
           :unnarrowed t))))

(with-eval-after-load 'citar
  (setq citar-bibliography "~/Projects/private-notes/refs.bib"))

;; Cuda
(add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode))
(setq gud-gdb-command-name "cuda-gdb annotate=3")

;; CPP style
(when (modulep! :lang cc)
  (c-add-style
   "cc" '((c-comment-only-line-offset . 0)
          (c-hanging-braces-alist (brace-list-open)
                                  (brace-entry-open)
                                  (substatement-open after)
                                  (block-close . c-snug-do-while)
                                  (arglist-cont-nonempty))
          (c-cleanup-list brace-else-brace)
          (c-offsets-alist
           (knr-argdecl-intro . 0)
           (substatement-open . 0)
           (substatement-label . 0)
           (statement-cont . +)
           (case-label . 0)
           ;; align args with open brace OR don't indent at all (if open
           ;; brace is at eolp and close brace is after arg with no trailing
           ;; comma)
           (brace-list-intro . 0)
           (brace-list-close . -)
           (arglist-intro . +)
           (arglist-close +cc-lineup-arglist-close 0)
           ;; don't over-indent lambda blocks
           (inline-open . 0)
           (inlambda . 0)
           (innamespace . [0])
           ;; indent access keywords +1 level, and properties beneath them
           ;; another level
           (access-label . [0])
           ;; (inclass +cc-c++-lineup-inclass +)
           (inclass +)
           (label . 0))))
  (when (listp c-default-style)
    (setf (alist-get 'c-mode c-default-style) "cc")
    (setf (alist-get 'c++-mode c-default-style) "cc")))

;; UI
(setq evil-insert-state-cursor 'box)
(after! lsp-mode
  (setq-default lsp-clients-clangd-args "--header-insertion=never")
  (add-hook! '(python-mode c-mode c++-mode rustic-mode)
    (when (display-graphic-p)
      (lsp-headerline-breadcrumb-mode)))
  (add-hook! rustic-mode
    (cmd! (lsp-rust-analyzer-inlay-hints-mode t)
          (setq-local lsp-rust-analyzer-server-display-inlay-hints t))))
(use-package! treemacs
  :init
  (setq +treemacs-git-mode 'extended)
  :config
  ;; buggy
  ;; (treemacs-tag-follow-mode)
  (treemacs-project-follow-mode))

(after! eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd"
                    "-j=8"
                    "--log=error"
                    "--malloc-trim"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0")))
  (use-package! breadcrumb
    :config
    (breadcrumb-mode)))

;; ;; Tabnine
;; (use-package! company-tabnine
;;   :after company
;;   :config
;;   (after! company
;;     (setq +lsp-company-backends '(company-tabnine :separate company-capf company-yasnippet))
;;     (setq company-show-numbers t)
;;     (setq company-idle-delay 0)))

(after! company
  (setq company-tooltip-minimum-width 100)
  (setq company-tooltip-maximum-width 100)
  (setq +lsp-company-backends '(company-capf :separate company-yasnippet)))

(unless (modulep! :editor evil)
  (setq-default doom-leader-alt-key "M-SPC")
  (setq-default doom-localleader-alt-key "M-SPC m"))

;; lsp-bridge
(unless (or (modulep! :tools lsp)
            (modulep! :complete company))
  (use-package! lsp-bridge
    :hook
    (python-base-mode . lsp-bridge-mode)
    (c++-mode . lsp-bridge-mode)
    (c++-ts-mode . lsp-bridge-mode)
    (rustic-mode . lsp-bridge-mode)

    :init
    (require 'yasnippet)
    (yas-global-mode 1)

    (require 'lsp-bridge)
    (global-lsp-bridge-mode)
    (setq lsp-bridge-c-lsp-server "clangd")
    (setq acm-enable-yas nil)
    (setq acm-enable-tabnine nil)
    (setq acm-enable-codeium nil)
    ;; (setq lsp-bridge-signature-show-function 'lsp-bridge-signature-posframe)
    (setq lsp-bridge-enable-hover-diagnostic t)

    :config
    (map!
     :mode prog-mode
     (:leader
      :desc "Rename symbol" "cr" #'lsp-bridge-rename
      :desc "Diagnostics list" "cx" #'lsp-bridge-diagnostic-list
      :desc "Code actions" "ca" #'lsp-bridge-code-action
      :desc "Format document" "cf" #'lsp-bridge-code-format))

    (add-to-list '+lookup-definition-functions #'lsp-bridge-find-def)
    (add-to-list '+lookup-implementations-functions #'lsp-bridge-find-impl)
    (add-to-list '+lookup-references-functions #'lsp-bridge-find-references)
    (add-to-list '+lookup-type-definition-functions #'lsp-bridge-find-type-def)
    (add-to-list '+lookup-documentation-functions #'lsp-bridge-popup-documentation)

    (unless (display-graphic-p)
      (with-eval-after-load 'acm
        (require 'acm-terminal)))))

(defun +display-vga-p ()
  (not (char-displayable-p ?里)))

;; (when (modulep! :ui modeline +light)
;;   (general-after-init
;;     (when (modulep! :tools lsp +eglot)   ; Only needs this for eglot
;;       (add-to-list 'mode-line-misc-info
;;                    '(flymake-mode
;;                      (" ["
;;                       flymake-mode-line-error-counter
;;                       flymake-mode-line-warning-counter
;;                       flymake-mode-line-note-counter
;;                       "] "))
;;                    nil)
;;       (setq eglot--mode-line-format '("Eglot")))
;;     (setq-default +modeline-format-left
;;                   (remove '+modeline-position +modeline-format-left))
;;     (setq-default +modeline-format-right
;;                   '(""  +modeline-modes
;;                     (vc-mode
;;                      ("  " "" vc-mode " "))
;;                     mode-line-misc-info
;;                     +modeline-position
;;                     "  " +modeline-encoding
;;                     (+modeline-checker
;;                      ("" +modeline-checker "   "))))
;;     (setq +modeline-position '("  %l:%C  "))
;;     (display-battery-mode)))

(c-set-offset 'innamespace 0)

(defun my-before-switch-term (&rest r)
  (when (doom-project-root)
    (cd (doom-project-root))))
(advice-add '+term/toggle :before #'my-before-switch-term)
(advice-add '+term/here :before #'my-before-switch-term)

(add-hook! org-mode (setq-local word-wrap-by-category t))
(setq-default org-tags-column -80)
(map! :map org-mode-map
      :localleader :desc "Remove org-babel result" :n "k" #'org-babel-remove-result-one-or-many)
(after! elfeed
  ;; (add-hook 'elfeed-search-mode-hook #'elfeed-update)
  (setq-default elfeed-search-filter "@1-days-ago +mustread +unread"))

(unless (display-graphic-p)
  (defun my/replace-tab ()
    (interactive)
    (if (region-active-p)
        (indent-for-tab-command)
      (better-jumper-jump-forward)))
  (map! :n "TAB" #'my/replace-tab)

  ;; BUG: doom-modeline-core.el L1204 -- doom-modeline-propertize-icon abnormally return nil on terminal
  (use-package doom-modeline
    :custom
    (doom-modeline-icon nil)))

(when (display-graphic-p)
  (use-package! rime
    :custom
    (default-input-method "rime")
    :config
    (use-package! rime-regexp
      :config
      (rime-regexp-mode))))

;; VGA support
(general-after-init
  (when (+display-vga-p)
    (set-face-foreground 'glyphless-char
                         (face-attribute 'default :background))
    (set-face-background 'glyphless-char
                         (face-attribute 'default :foreground))
    (after! company
      (set-face-foreground 'company-tooltip-selection
                           (face-attribute 'tooltip :background))
      (set-face-background 'company-tooltip-selection
                           (face-attribute 'tooltip :foreground)))
    (after! vertico
      (set-face-foreground 'vertico-current
                           (face-attribute 'default :background))
      (set-face-background 'vertico-current
                           (face-attribute 'default :foreground)))))

(use-package! leetcode
  :config
  (setq leetcode-prefer-language "cpp")
  (setq leetcode-save-solutions t)
  (setq leetcode-directory "~/Projects/Leetcode"))

(use-package! consult-todo
  :config
  (map! :leader :desc "Query todos" :nie"s q" #'consult-todo))

;; (use-package! telega
;;   :config
;;   (setq telega-proxies '((:server "localhost" :port 7890 :enable t :type (:@type "proxyTypeSocks5")))))

