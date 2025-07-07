;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
                                        ;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
                                        ;(package! another-package
                                        ;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
                                        ;(package! this-package
                                        ;  :recipe (:host github :repo "username/repo"
                                        ;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
                                        ;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
                                        ;(package! builtin-package :recipe (:nonrecursive t))
                                        ;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
                                        ;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
                                        ;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
                                        ;(unpin! pinned-package)
;; ...or multiple packages
                                        ;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
                                        ;(unpin! t)

;; (package! org-modern)
;; (package! nov)
(package! vscode-dark-plus-theme)
(unpin! doom-themes)
(package! ef-themes)
(package! color-theme-sanityinc-tomorrow)

;; (package! org-mind-map)
(package! disable-mouse
  :recipe (:host github :repo "purcell/disable-mouse"))

(package! ccls :disable t)
(package! activity-watch-mode)
(package! alert)
(package! edit-server)

(package! gptel)
(package! toc-org)
(package! csv-mode)
(package! org-yt
  :recipe (:host github :repo "TobiasZawada/org-yt"))
(package! org-remoteimg
  :recipe (:host github :repo "gaoDean/org-remoteimg"))
(package! copilot)

(package! tree-sitter)
(package! tree-sitter-langs)

(package! clipetty)
;; (package! xclip :disable t)

;; (when (package! lsp-bridge
;;         :recipe (:host github
;;                  :repo "manateelazycat/lsp-bridge"
;;                  :branch "master"
;;                  :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
;;                  ;; do not perform byte compilation or native compilation for lsp-bridge
;;                  :build (:not compile)))
;;   (package! eglot :disable t)
;;   (unless (display-graphic-p)
;;     (package! popon
;;       :recipe (:host nil :repo "https://codeberg.org/akib/emacs-popon.git"))
;;     (package! acm-terminal
;;       :recipe (:host github :repo "twlz0ne/acm-terminal"))))

(when (modulep! :tools lsp)
  (package! emacs-lsp-booster :recipe (:host github :repo "blahgeek/emacs-lsp-booster"))
  (when (modulep! :tools lsp +eglot)
    (package! eglot-booster :recipe (:host github :repo "jdtsmith/eglot-booster"))))

(package! catppuccin-theme)
(package! bison-mode
  :recipe (:host github
           :repo "Wilfred/bison-mode"))
(package! typst-ts-mode
  :recipe (:host sourcehut
           :repo "meow_king/typst-ts-mode"))

(package! company-tabnine)
(package! llvm :recipe
  (:host github
   :repo "VitalyAnkh/llvm-tools"
   :files ("*.el")))

;; (package! anaconda-mode :disable t)
(package! cuda-mode :disable t)
(package! telega)
(package! breadcrumb
  :recipe (:host github
           :repo "joaotavora/breadcrumb"))

(package! leetcode
  :recipe (:host github
           :repo "kaiwk/leetcode.el"))

(package! rime)
(package! rime-regexp
  :recipe (:host github
           :repo "colawithsauce/rime-regexp.el"))

(package! exec-path-from-shell)

(package! consult-todo
  :recipe (:host github
           :repo "liuyinz/consult-todo"))
(package! todoist)
(package! org-excalidraw
  :recipe (:host github
           :repo "wdavew/org-excalidraw"))

(package! ts)
(package! esxml)
(package! unpackaged
  :recipe (:host github
           :repo "alphapapa/unpackaged.el"))
(package! emacs-lorem-ipsum
  :recipe (:host github :repo "jschaf/emacs-lorem-ipsum"))

(package! just-mode)

(package! citre
  :recipe (:host github
           :repo "universal-ctags/citre"))

(package! fanyi
  :recipe (:host github
           :repo "condy0919/fanyi.el"))

(package! anki-helper
  :recipe (:host github
           :repo "Elilif/emacs-anki-helper"))

(package! cal-china-x)

(package! ox-pandoc)
(package! kdl-mode)

;; (when (modulep! :tools lsp +eglot)
;;   (unpin! eglot))

;; BUG: https://github.com/doomemacs/doomemacs/issues/7334
;; (package! org
;;   :recipe (:host github
;;            ;; REVIEW: I intentionally avoid git.savannah.gnu.org because of SSL
;;            ;;   issues (see #5655), uptime issues, download time, and lack of
;;            ;;   shallow clone support.
;;            :repo "emacs-straight/org-mode"
;;            :files (:defaults "etc")
;;            :depth 1
;;            ;; HACK: Org has a post-install step that generates org-version.el
;;            ;;   and org-loaddefs.el, but Straight doesn't invoke this step, and
;;            ;;   the former doesn't work if the Org repo is a shallow clone.
;;            ;;   Rather than impose the network burden of a full clone (and other
;;            ;;   redundant work in Org's makefile), I'd rather fake these files
;;            ;;   instead. Besides, Straight already produces a org-autoloads.el,
;;            ;;   so org-loaddefs.el isn't needed.
;;            :build t
;;            :pre-build
;;            (progn
;;              (with-temp-file "org-loaddefs.el")
;;              (with-temp-file "org-version.el"
;;                (let ((version
;;                       (with-temp-buffer
;;                         (insert-file-contents (doom-path "lisp/org.el") nil 0 1024)
;;                         (if (re-search-forward "^;; Version: \\([^\n-]+\\)" nil t)
;;                             (match-string-no-properties 1)
;;                           "Unknown"))))
;;                  (insert (format "(defun org-release () %S)\n" version)
;;                          (format "(defun org-git-version (&rest _) \"%s-??-%s\")\n"
;;                                  version (cdr (doom-call-process "git" "rev-parse" "--short" "HEAD")))
;;                          "(provide 'org-version)\n")))))
;;   :pin "9183e3c723b812360d1042196416d521db590e9f")
