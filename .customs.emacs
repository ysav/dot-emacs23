;;
;; File  .customs.emacs - These commands are executed when the GNU emacs init.el file
;;                        loads the file.
;;

;; Comment out this line if debug of customs.emacs is not required
;;(setq debug-on-error t)

(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;; For org-mode
;; - auto-open .org files in org mode
;; - map convenient short-cut keys 
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(require 'ox-reveal)
(setq org-reveal-root "file:///c:/install/reveal.js-master")
(add-to-list 'org-export-backends 'reveal)

(require 'ox-taskjuggler)
(add-to-list 'org-export-backends 'taskjuggler)

(eval-after-load "org"
  '(require 'ox-md nil t))

;; taskjuggler options
;;(setq org-export-taskjuggler-target-version 3.1)
;;(setq org-export-taskjuggler-default-reports (quote (
;;  "include \"reports.tji\"")))

;; Activat builtin ditaa for ascii art to bitmap conversion
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t))) ; this line activates ditaa

;; For msys grep and find
(setenv "PATH"
  (concat
   ;; Change this with your path to MSYS bin directory
   "C:\\MinGW\\msys\\1.0\\bin;"
   (getenv "PATH")))

;; With numeric ARG, display the tool bar if and only if ARG is
;; positive.  Tool bar has icons document (read file), folder (read
;; directory), X (discard buffer), disk (save), disk+pen (save-as),
;; back arrow (undo), scissors (cut), etc.
(tool-bar-mode 0)

;; arg >= 1 enable the menu bar. Menu bar is the File, Edit, Options,
;; Buffers, Tools, Emacs-Lisp, Help
(menu-bar-mode 1)

;; enabel third part contrib tools shipped but not enabled by default (e.g, ditaa)
;; (add-to-list 'load-path "/contrib")

;; For opening files from within windows explorer in existing instance of emacs
(server-start)

;; add emacs color themes
;; My favourites are clarity, hober and taming-mr-arneson
(add-to-list 'load-path "~/.emacs.d/site-lisp/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-clarity)))

;; use package column-marker to highlight column 80 in c-mode
;; from (http://www.emacswiki.org/emacs/column-marker.el)
(require 'column-marker)

;; Highlight column 80 in C mode.
(add-hook 'c-mode-common-hook (lambda () (interactive) (column-marker-1 80)))
(add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 80)))
;;;;;;;;;;;;;;;;;;;;;;;;
;; Smart tabs
;;;;;;;;;;;;;;;;;;;;;;;;

;; set tab distance to something, so it doesn't change randomly and confuse people
;; NOTE nothing good can come of setting tab-width to a different value from c-basic-offset.
(setq c-default-style "bsd"
      c-basic-offset 4)

;; disable tabs globally and reactivate for modes with smart tab handling 
(setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
(setq default-tab-width 4)

 ;; enable use of smart tabs in C-mode
(add-hook 'c-mode-common-hook
        (lambda () (setq indent-tabs-mode t)))
(add-hook 'c-mode-common-hook #'smart-tabs-mode)

;; use smart tabs minor-mode (needs to be explicitly switched to via M-x smart-tabs-mode)
;; Have been unable to get smart tabs to work (always get multiple tabs used to align to multiple tab-stops away even for only one level of indentation).
(require 'smart-tabs-mode)
(autoload 'smart-tabs-mode "smart-tabs-mode"
  "Intelligently indent with tabs, align with spaces!")

;;(autoload 'smart-tabs-mode-enable "smart-tabs-mode")
;;(autoload 'smart-tabs-advice "smart-tabs-mode")

;; Load all the following in one pass
(smart-tabs-insinuate 'c)
;;(add-hook 'c-mode-hook (lambda ()
;;			 (smart-tabs-mode-enable)
;;			 (smart-tabs-advice c-indent-line c-basic-offset)))

;;
;; ECB
;; 

;; (add to list 'load-path
;;      "" )

;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown minor mode
;;;;;;;;;;;;;;;;;;;;;;;

(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.md" . markdown-mode) auto-mode-alist))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Better auto-complete
;;;;;;;;;;;;;;;;;;;;;;;;

;;(require 'auto-complete)
;;(global-auto-complete-mode t)

;;;;;;;;;;;;;;;;;;;;;
;; Template System ;;
;;;;;;;;;;;;;;;;;;;;;

;; RPM : added for better python support.
;; RPM : removed because screws with the default cc-mode tab settings and
;; RPM : smart tabs.

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet-f28a3df")
(require 'yasnippet)
(yas-global-mode 1)

(yas--initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-f28a3df/snippets")

;;;;;;;;;;;;
;; PYTHON ;;
;;;;;;;;;;;;

;; ***** python.el and other python modes *****

(setq python-shell-interpreter "\"C:/Python27/python.exe\"")

;; ***** python-mode.el  *****

(add-to-list 'load-path "~/.emacs.d/site-lisp/python-mode.el-6.0.2/")

(autoload 'python-mode "python-mode" "Python editing mode." t)
    (setq auto-mode-alist
           (cons '("\\.py$" . python-mode) auto-mode-alist))
     (setq interpreter-mode-alist
           (cons '("python" . python-mode) interpreter-mode-alist))

;; In Python use spaces as stated in PEP8
(add-hook 'python-mode-common-hook
              (lambda () (setq indent-tabs-mode t)))

;; Disable python shell feature which removes current working dir from path
;; (setq python-remove-cwd-from-path nil)

;; (defadvice py-execute-buffer (around python-keep-focus activate)
;;  "The advice to make focus python source code after execute command `py-execute-buffer'."
;;   (let ((remember-window (selected-window))
;;           (remember-point (point)))
;;     ad-do-it
;;     (select-window remember-window)
;;     (goto-char remember-point)))

;; ***** IPython ******

;; load ipython.el if ipython is available
;; (when (executable-find "\"C:/Python27/Lib/site-packages/IPython\"")
;;   (require 'ipython nil 'noerror))
;; (when (featurep 'ipython)
;;   (setq python-python-command "ipython -cl")
;;   (setq python-command python-python-command))

;;(setq py-default-interpreter "\"C:/Python27/Lib/site-packages/IPython\"")

(setq load-path
       (append (list nil
 		    "~/.emacs.d/ropemacs-0.6"
                     )
               load-path))

;; (require 'ipython)
;; (setq py-python-command-args '( "--colors" "Linux"))
;; (require 'python-mode)

;;(pymacs-load "ropemacs" "rope-")

;; (defun rgr/python-execute()
;;   (interactive)
;;   (if mark-active
;;       (py-execute-string (buffer-substring-no-properties (region-beginning) (region-end)))
;;     (py-execute-buffer)))

;; (global-set-key (kbd "C-c C-e") 'rgr/python-execute)

;; (add-hook 'python-mode-hook
;;            '(lambda () (eldoc-mode 1)) t)

;; (provide 'python-programming)

 ;; associate shift tab with reverse tabbing (backtab) -- NOT-WORKING as backtab is undefined
;; (define-key function-key-map [S-tab] [backtab])

;; (defcustom py-indent-offset 4
;; "*Amount of offset per level of indentation.
;; `\\[py-guess-indent-offset]' can usually guess a good value when
;; you're editing someone else's Python code."
;; :type 'integer
;; :group 'python)

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/pymacs-v0.25-0/")

;; (autoload 'pymacs-apply "pymacs")
;; (autoload 'pymacs-call "pymacs")
;; (autoload 'pymacs-eval "pymacs" nil t)
;; (autoload 'pymacs-exec "pymacs" nil t)
;; (autoload 'pymacs-load "pymacs" nil t)
;; (autoload 'pymacs-autoload "pymacs")
;; (eval-after-load "pymacs"
;;   '(add-to-list 'pymacs-load-path "~/.emacs.d/site-lisp/pymacs-v0.25-0/"))

;; (require 'pymacs)
