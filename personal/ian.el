;;; package --- Summary
;; Personal config for Emacs, integrating with Prelude.

;;; Commentary:
;; Prelude offers personal customization via the personal/ dir.

;;; Code:
;; Add marmalade (buyer beware)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; require extra pacakages outside of prelude
(prelude-require-packages '(dash-at-point
                            ag
                            fzf
                            flycheck
                            nlinum
                            yasnippet
                            markdown-mode
                            ctags-update
                            etags-table
                            helm-etags-plus
                            terraform-mode
                            dotenv-mode))

;; (require 'el-get)
;; ;; Set el-get sources
;; (setq
;;  el-get-sources
;;  '(
;;    (:name etags-table
;;           :type emacswiki
;;           :features etags-table
;;           :after (progn ()
;;                    (setq etags-table-search-up-depth 10)
;;                    (setq etags-table-alist
;;                          (list
;;                           '("~/code/.*\\.\\([rb]\\)" "~/code/*/TAGS")
;;                           ))))
;;    ))

;; ;; now set our own packages
;; (setq
;;  my:el-get-packages
;;  '())

;; (setq my:el-get-packages
;;       (append my:el-get-packages
;;               (mapcar #'el-get-source-name el-get-sources)))

;; ;; install new packages and init already installed packages
;; (el-get 'sync my:el-get-packages)

;; for optionally supporting additional file extensions such as `.env.test' with this major mode
(add-to-list 'auto-mode-alist '("\\.env\\..*\\'" . dotenv-mode))

;; disable Emacs menubar
(menu-bar-mode -1)

(custom-set-variables
 ;; set yas snippet location to follow symlinks
 '(yas-snippet-dirs (list (file-truename "~/.emacs.d/snippets")))
 ;; use guru mode to disable noob keys
 '(guru-warn-only nil)
 ;; use sbcl for Common Lisp
 '(inferior-lisp-program "sbcl")
 ;; JavaScript 2 spaces for tab
 '(js2-basic-offset 2)
 ;; Line numbers, add space after
 '(nlinum-format "%d ")
 ;; Don't tabify after rectangle commands
 '(cua-auto-tabify-rectangles nil)
 ;; limit line length
 '(whitespace-line-column 120)
 '(org-agenda-files (list "~/Dropbox/org/work.org"
                          "~/Dropbox/org/home.org")))

;; Turn on yas snippets
(yas-global-mode)

;; cua-mode https://www.emacswiki.org/emacs/CuaMode
(cua-mode t)
(cua-selection-mode t)
;; No region when it is not highlighted
(transient-mark-mode 1)

(require 'etags-table)
(setq etags-table-alist
      (list
       '("~/code/.*\\.\\([rb]\\)" "~/code/*/TAGS")
       ))
(setq etags-table-search-up-depth 10)
(add-hook 'helm-etags-plus-select-hook 'etags-table-recompute)

(require 'ctags-update)
(setq ctags-update-command "/usr/local/bin/ctags")

;; disable tabs whitespace in golang buffers
(add-hook 'go-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'gofmt-before-save)
            (setq whitespace-style '(face empty trailing lines-tail))
            (setq tab-width 4)
            (setq indent-tabs-mode 1)))

;; run gofmt before save
(add-hook 'before-save-hook #'gofmt-before-save)

;; run terraform fmt before save
(add-hook 'terraform-mode-hook #'terraform-format-on-save-mode)

;; keybindings
(global-set-key (kbd "C-c C-d d") 'dash-at-point)
(global-set-key (kbd "C-c C-d e") 'dash-at-point-with-docset)
(global-set-key (kbd "M-g g") 'goto-line)
;; Unset ace-window, it's not helpful with more than one window (tmux)
(global-set-key [remap other-window] nil)
(global-unset-key (kbd "C-x o"))
(global-set-key (kbd "C-x o") 'other-window)

;; Show line numbers when using goto-line
(global-set-key [remap goto-line] 'goto-line-with-feedback)

(defun goto-line-with-feedback ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
      (progn
        (nlinum-mode 1)
        (goto-line (read-number "Goto line: ")))
    (nlinum-mode -1)))

;; In dired, M-> and M- never take me where I want to go.
;; That is, now they do.
;; Instead of taking me to the very beginning or very end, they now take me to the first or last file.
(defun dired-back-to-top ()
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 4))

(define-key dired-mode-map
  (vector 'remap 'beginning-of-buffer) 'dired-back-to-top)

(defun dired-jump-to-bottom ()
  (interactive)
  (end-of-buffer)
  (dired-next-line -1))

(define-key dired-mode-map
  (vector 'remap 'end-of-buffer) 'dired-jump-to-bottom)

(add-to-list 'auto-mode-alist '("/bash" . sh-mode))
(add-to-list 'auto-mode-alist '("\\.sh" . sh-mode))

(provide 'ian)
;;; ian.el ends here
