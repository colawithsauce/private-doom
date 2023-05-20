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
 my-font-size 18
 ;; doom-font (font-spec :family "CaskaydiaCove Nerd Font Mono" :size my-font-size :weight 'semilight)
 doom-font (font-spec :family "IBM Plex Mono" :size my-font-size)
 ;; doom-font (font-spec :family "Latin Modern Mono" :size my-font-size)
 ;; doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size my-font-size :weight 'semilight)
 doom-variable-pitch-font (font-spec :family "IBM Plex Sans" :size my-font-size)
 doom-unicode-font (font-spec :family  "Noto Color Emoji" :size my-font-size :weight 'semilight))

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
(setq doom-theme 'doom-gruvbox)

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

;; UI
(setq evil-insert-state-cursor 'box)
(after! lsp-mode
  (add-hook! '(python-mode c-mode c++-mode)
             (lambda ()
               (when (display-graphic-p)
                 (lsp-headerline-breadcrumb-mode)))))
(use-package! treemacs
  :init
  (setq +treemacs-git-mode 'extended)
  :config
  ;; buggy
  ;; (treemacs-tag-follow-mode)
  (treemacs-project-follow-mode))

(after! eglot
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

(use-package! company
  :custom
  (company-tooltip-minimum-width 100)
  (company-tooltip-maximum-width 100))

;; ;; lsp-bridge
;; (use-package lsp-bridge
;;   ;; :delight (lsp-bridge-mode "")
;;   :config
;;   (require 'yasnippet)
;;   (yas-global-mode 1)

;;   (require 'lsp-bridge)
;;   (global-lsp-bridge-mode)
;;   (setq lsp-bridge-c-lsp-server "clangd")
;;   (setq acm-enable-yas nil)
;;   (setq acm-enable-tabnine nil)
;;   (setq acm-enable-codeium t)
;;   ;; (setq lsp-bridge-signature-show-function 'lsp-bridge-signature-posframe)
;;   (setq lsp-bridge-enable-hover-diagnostic t)
;;   (map!
;;    :mode prog-mode
;;    (:leader
;;     :desc "Rename symbol" "cr" #'lsp-bridge-rename
;;     :desc "Diagnostics list" "cx" #'lsp-bridge-diagnostic-list
;;     :desc "Code actions" "ca" #'lsp-bridge-code-action
;;     :desc "Format document" "cf" #'lsp-bridge-code-format))

;;   (add-to-list '+lookup-definition-functions #'lsp-bridge-find-def)
;;   (add-to-list '+lookup-implementations-functions #'lsp-bridge-find-impl)
;;   (add-to-list '+lookup-references-functions #'lsp-bridge-find-references)
;;   (add-to-list '+lookup-type-definition-functions #'lsp-bridge-find-type-def)
;;   (add-to-list '+lookup-documentation-functions #'lsp-bridge-popup-documentation)


;;   (unless (display-graphic-p)
;;     (with-eval-after-load 'acm
;;       (require 'acm-terminal))))

(c-set-offset 'innamespace 0)

(use-package! rime
  :custom
  (default-input-method "rime"))
