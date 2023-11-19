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

(package! org-modern)
(package! nov)

(package! org-mind-map)
(package! disable-mouse
  :recipe (:host github :repo "purcell/disable-mouse"))

(package! ccls
  :disable t)

;; (package! xclip :disable t)

;; (package! nerd-icons-completion
;;   :recipe (:host github :repo "rainstormstudio/nerd-icons-completion"))
;; (package! nerd-icons)
;; (unpin! doom-modeline)

;; lsp-bridge
;; (package! lsp-bridge
;;           :recipe (:host github :repo "manateelazycat/lsp-bridge"
;;                    :files ("*")))
;; (package! acm :recipe (:host github :repo "manateelazycat/lsp-bridge" :files ("acm")))
;; ;; 如果没有上面这一行，安装 acm-terminal 的时候 doom sync 会报错，提示找不到 acm 这个包，不装 acm-terminal 不$
;; (package! popon)
;; (package! acm-terminal :recipe (:host github :repo "twlz0ne/acm-terminal"))

;; (package! company-tabnine)
(package! cuda-mode :disable t)
(package! rime)
(package! telega)
(package! breadcrumb
  :recipe (:host github
           :repo "joaotavora/breadcrumb"))

(package! leetcode
  :recipe (:host github
           :repo "kaiwk/leetcode.el"))

(package! rime-regexp
  :recipe (:host github
           :repo "colawithsauce/rime-regexp.el"))

(package! consult-todo
  :recipe (:host github
           :repo "liuyinz/consult-todo"))

(package! citre
  :recipe (:host github
           :repo "universal-ctags/citre"))

(package! fanyi
  :recipe (:host github
           :repo "condy0919/fanyi.el"))

;; BUG: https://github.com/doomemacs/doomemacs/issues/7334
(package! org
  :recipe (:host github
           ;; REVIEW: I intentionally avoid git.savannah.gnu.org because of SSL
           ;;   issues (see #5655), uptime issues, download time, and lack of
           ;;   shallow clone support.
           :repo "emacs-straight/org-mode"
           :files (:defaults "etc")
           :depth 1
           ;; HACK: Org has a post-install step that generates org-version.el
           ;;   and org-loaddefs.el, but Straight doesn't invoke this step, and
           ;;   the former doesn't work if the Org repo is a shallow clone.
           ;;   Rather than impose the network burden of a full clone (and other
           ;;   redundant work in Org's makefile), I'd rather fake these files
           ;;   instead. Besides, Straight already produces a org-autoloads.el,
           ;;   so org-loaddefs.el isn't needed.
           :build t
           :pre-build
           (progn
             (with-temp-file "org-loaddefs.el")
             (with-temp-file "org-version.el"
               (let ((version
                      (with-temp-buffer
                        (insert-file-contents (doom-path "lisp/org.el") nil 0 1024)
                        (if (re-search-forward "^;; Version: \\([^\n-]+\\)" nil t)
                            (match-string-no-properties 1)
                          "Unknown"))))
                 (insert (format "(defun org-release () %S)\n" version)
                         (format "(defun org-git-version (&rest _) \"%s-??-%s\")\n"
                                 version (cdr (doom-call-process "git" "rev-parse" "--short" "HEAD")))
                         "(provide 'org-version)\n")))))
  :pin "ca873f7fe47546bca19821f1578a6ab95bf5351c")
