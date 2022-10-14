(setq tramp-terminal-type "tramp")
;; programming settings
(add-hook 'prog-mode-hook 'spacemacs/toggle-fill-column-indicator)  ;; toggle fill column indicator on
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))  ;; underscore as part of word
;; update copyright when saving and fix the years to match my pattern
(add-hook 'before-save-hook #'my-copyright-update)  ;; update copyrights on save
(setq copyright-year-ranges t)  ;; fix up the years so that we get a dash
(setq copyright-query nil)  ;; don't ask to update copyright
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)  ;; increment number
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)  ;; decrement number
(setq global-git-commit-mode t)  ;; use emacs for git commits
(xterm-mouse-mode -1)  ;; normal copy paste with mouse in terminal
(add-hook 'c-mode-common-hook 'my/set-c-ctyle)  ;; apply my c-style
(add-hook 'python-mode-hook (flycheck-mode 0))
(setq whitespace-style (quote (face empty tabs lines-tail trailing)))  ;; display annoying whitespaces
(whitespace-mode 't)  ;; turn on whitespace minor mode
(add-to-list 'auto-mode-alist '("\\.tcc" . c++-mode))  ;; template files

(setq toggle-scroll-bar -1)  ;; don't show scroll bar

(require 'org-tempo)

;; pretty colors during compilation
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region compilation-filter-start (point))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; org-page
(require 'org-page)
(setq op/repository-directory "~/workspace/erichlf.github.io")
(setq op/site-domain "https://erichlf.github.io")
(setq op/personal-github-link "https://github.com/erichlf")
(setq op/site-main-title "That Stuff I Found Along the Way")
(setq op/site-sub-title "")
(setq op/repository-html-branch "main")
(setq op/personal-disqus-shortname (password-store-get "secrets/disqus-user"))
(setq user-full-name "Erich L Foster")
(setq user-mail-address "")

;; projectile
(setq projectile-project-search-path '("~/workspace"))
(setq directory-abbrev-alist '(("^/checkout/src" . "/home/seegrid.local/efoster/workspace/Seegrid/blue")))
(add-hook 'find-file-hook 'load-dir-settings)

;; org-agenda
(setq org-log-into-drawer t)  ;; log state changes to a drawer
(setq org-agenda-show-outline-path t)  ;; show items path in echo area
(setq org-agenda-log-mode-items (quote (state clocked)))
(setq org-clock-report-include-clocking-task t)  ;; add current item to clock table
(setq org-agenda-skip-scheduled-if-done t)  ;; don't display messages or scheduled items if done
(setq org-todo-keywords '((sequence "TODO(t)" "IN PROGRESS(i!)" "STALLED(s@/!)" "|" "WATCH LISTED(l!)" "HANDED OFF(h@/!)" "DONE(d!)" "WON'T FIX(w@/!)")))
(setq org-todo-keyword-faces '(("TODO" . "#dc752f") ("IN PROGRESS" . "#4f97d7") ("STALLED" . "#f2241f")
                                ("WATCH LISTED" . "#86dc2f") ("HANDED OFF" . "#86dc2f") ("DONE" . "#86dc2f")
                                ("WON'T FIX" . "#86dc2f")))
(setq org-agenda-clockreport-parameter-plist
  (quote (:hidefiles t :link t :maxlevel 4 :fileskip0 t :compact t :formula %)))
(org-clock-persistence-insinuate)  ;; Resume clocking task when emacs is restarted
(setq org-clock-persist t)  ;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-in-resume t)  ;; Resume clocking task on clock-in if the clock is open
(setq org-clock-persist-query-resume nil)  ;; Do not prompt to resume an active clock, just resume it
(setq org-clock-out-when-done t)  ;; Clock out when moving task to a done state
(setq org-clock-report-include-clocking-task t)  ;; Include current clocking task in clock reports
(setq org-clock-idle-time 90)  ;; detect idle time and ask what to do with it
(setq org-pretty-entities t)  ;; use pretty things for the clocktable
(setq org-babel-python-command "python3")  ;; use python3 in org-mode code
(add-hook 'org-after-todo-state-change-hook 'my/org-todo-state-change-clock)
(org-babel-do-load-languages 'org-babel-load-languages '((dot . t)))

;; org-roam
;; (setq org-roam-directory "~/org/notes")
;; (org-roam-setup)

(setq org-image-actual-width nil)

;; logview
(setq logview-guess-lines 1250)  ;; sometimes our headers are very long
(setq logview-additional-timestamp-formats
  '(("SEEGRID" (regexp . "[0-9]\\{10\\} [ 0-9]\\{6\\}"))
    ("IRIS" (regexp . "[0-9]\\{10\\}.[ 0-9]\\{9\\}")))
  )
(setq logview-additional-level-mappings
  '(("SEEGRID"
      (error "ERROR")
      (warning "WARN")
      (information "INFO")
      (debug "DEBUG")
      (trace)
      (aliases))))
(setq logview-additional-submodes
  '(("SEEGRID"
      (format . "[TIMESTAMP THREAD LEVEL] MESSAGE")
      (levels . "SEEGRID")
      (timestamp "SEEGRID")
      (aliases))
    ("PLATINUM"
      (format . "[TIMESTAMP THREAD LEVEL NAME] MESSAGE")
      (levels . "SEEGRID")
      (timestamp "SEEGRID")
      (aliases))
    ("TEST"
      (format . "[TIMESTAMP THREAD NAME LEVEL] MESSAGE")
      (levels . "SEEGRID")
      (timestamp "SEEGRID")
      (aliases))
     ("IRIS"
       (format . "[THREAD] [IGNORED[LEVEL] [TIMESTAMP] [NAME]: MESSAGE")
       (levels . "SEEGRID")
       (timestamp "IRIS")
       (aliases)))
  )

;; misc
(setq doc-view-continuous 't)

;; my functions follow

;; work around for broken dir-locals loading
(defun recursive-load-dir-settings (currentfile)
  (let ((lds-dir (locate-dominating-file currentfile "settings.el")))
    (when lds-dir
      (progn
        (load-file (concat lds-dir "settings.el"))
        (recursive-load-dir-settings (file-truename(concat lds-dir "..")))))))

(defun load-dir-settings()
  (interactive)
  (when buffer-file-name
    (recursive-load-dir-settings buffer-file-name)))

(defun my-copyright-update ()
  (copyright-update)
  (save-excursion (copyright-fix-years)))

(defun my/org-todo-state-change-clock ()
  "Clock in or out of tasks when state changes"
  (when (string= org-state "IN PROGRESS")
    (org-clock-in))
  (when (string= org-state "HANDED OFF")
    (org-clock-out-if-current))
  )

(defun my/get-ticket-num (link)
  "Use a regular expression to determine the ticket number in a link"
  (save-match-data
    (and
      (string-match "\\([A-z-a-z_-]+-[0-9]+\\)" link)
      (match-string 1 link)
      ))
  )

(defun my/get-pr-num (link)
  "Use a regular expression to determine the code review number in a link"
  (save-match-data
    (and
      (string-match "\\([A-z-a-z_-]+\\)/pulls/\\([0-9]+\\)" link)
      (setq project (match-string 1 link)
        ticket (match-string 2 link))
      (if (> (length project) 0) (concat project "#" ticket) project)
      ))
  )

(defun my/get-ticket (link)
  "Use a regular expression to determine the ticket in link"
  (if (equal (my/get-pr-num link) nil) (my/get-ticket-num link) (get-pr-num link))
  )

(defun my/ticket-steps (link)
  "Provides a string that has my standard ticket process"
  (interactive)
  (setq priority
    (read-string "PRIORITY: "))
  (setq title
    (read-string "TITLE: "))
  (setq ticket
    (my/get-ticket-num link))
  (setq header (format "\n* TODO [#%s] %s ([[%s][%s]]) [/]
   :PROPERTIES:
   :CUSTOM_ID: %s
   :ORDERED: t
   :END:\n" priority title link ticket ticket))
  (setq steps "** TODO Implement
** TODO Code Review
** TODO Branch Test
** TODO Integrate
** TODO Integration Test
** TODO Sign Off\n")
  (s-concat header steps)
  )

;; function to load my c-style
(defun my/set-c-ctyle ()
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (c-add-style "seegrid" my/seegrid-iris-c-style t)
  )

;; define the seegrid coding style
(defconst my/seegrid-iris-c-style ()
  '("Seegrid IRIS C/C++ Programming Style"
               (c-basic-offset . 2)     ; Guessed value
               (c-offsets-alist
                (arglist-cont . 0)      ; Guessed value
                (arglist-intro . ++)    ; Guessed value
                (block-close . 0)       ; Guessed value
                (catch-clause . 0)      ; Guessed value
                (defun-block-intro . +) ; Guessed value
                (defun-close . 0)       ; Guessed value
                (defun-open . 0)        ; Guessed value
                (else-clause . 0)       ; Guessed value
                (inline-close . 0)      ; Guessed value
                (innamespace . 0)       ; Guessed value
                (member-init-cont . 0)  ; Guessed value
                (member-init-intro . ++) ; Guessed value
                (namespace-close . 0)    ; Guessed value
                (namespace-open . 0)     ; Guessed value
                (statement . 0)             ; Guessed value
                (statement-block-intro . +) ; Guessed value
                (statement-cont . ++)   ; Guessed value
                (substatement-open . 0) ; Guessed value
                (topmost-intro . 0)     ; Guessed value
                (topmost-intro-cont . 0) ; Guessed value
                (access-label . -)
                (annotation-top-cont . 0)
                (annotation-var-cont . +)
                (arglist-close . c-lineup-close-paren)
                (arglist-cont-nonempty . c-lineup-arglist)
                (block-open . 0)
                (brace-entry-open . 0)
                (brace-list-close . 0)
                (brace-list-entry . 0)
                (brace-list-intro . +)
                (brace-list-open . 0)
                (c . c-lineup-C-comments)
                (case-label . 0)
                (class-close . 0)
                (class-open . 0)
                (comment-intro . c-lineup-comment)
                (composition-close . 0)
                (composition-open . 0)
                (cpp-define-intro c-lineup-cpp-define +)
                (cpp-macro . -1000)
                (cpp-macro-cont . +)
                (do-while-closure . 0)
                (extern-lang-close . 0)
                (extern-lang-open . 0)
                (friend . 0)
                (func-decl-cont . +)
                (inclass . +)
                (incomposition . +)
                (inexpr-class . +)
                (inexpr-statement . +)
                (inextern-lang . +)
                (inher-cont . c-lineup-multi-inher)
                (inher-intro . +)
                (inlambda . 0)
                (inline-open . +)
                (inmodule . +)
                (knr-argdecl . 0)
                (knr-argdecl-intro . +)
                (label . 2)
                (lambda-intro-cont . +)
                (module-close . 0)
                (module-open . 0)
                (objc-method-args-cont . c-lineup-ObjC-method-args)
                (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
                (objc-method-intro .
                                   [0])
                (statement-case-intro . +)
                (statement-case-open . 0)
                (stream-op . c-lineup-streamop)
                (string . -1000)
                (substatement . +)
                (substatement-label . 2)
                (template-args-cont c-lineup-template-args +))))

(defconst my/seegrid-blue-c-style ()
  '("Seegrid BLUE C/C++ Programming Style"
     (c-basic-offset . 4)     ; Guessed value
     (c-offsets-alist
          (block-close . 0)       ; Guessed value
          (case-label . 0)        ; Guessed value
          (defun-block-intro . +) ; Guessed value
          (defun-close . 0)       ; Guessed value
          (defun-open . 0)        ; Guessed value
          (inline-close . 0)      ; Guessed value
          (innamespace . 0)       ; Guessed value
          (member-init-cont . 0)  ; Guessed value
          (member-init-intro . +) ; Guessed value
          (statement . 0)             ; Guessed value
          (statement-block-intro . +) ; Guessed value
          (statement-case-intro . +) ; Guessed value
          (statement-case-open . +)  ; Guessed value
          (statement-cont . +)    ; Guessed value
          (topmost-intro . 0)     ; Guessed value
          (access-label . -)
          (annotation-top-cont . 0)
          (annotation-var-cont . +)
          (arglist-close . c-lineup-close-paren)
          (arglist-cont c-lineup-gcc-asm-reg 0)
          (arglist-cont-nonempty . c-lineup-arglist)
          (arglist-intro . +)
          (block-open . 0)
          (brace-entry-open . 0)
          (brace-list-close . 0)
          (brace-list-entry . c-lineup-under-anchor)
          (brace-list-intro . +)
          (brace-list-open . 0)
          (c . c-lineup-C-comments)
          (catch-clause . 0)
          (class-close . 0)
          (class-open . 0)
          (comment-intro . c-lineup-comment)
          (composition-close . 0)
          (composition-open . 0)
          (cpp-define-intro c-lineup-cpp-define +)
          (cpp-macro . -1000)
          (cpp-macro-cont . +)
          (do-while-closure . 0)
          (else-clause . 0)
          (extern-lang-close . 0)
          (extern-lang-open . 0)
          (friend . 0)
          (func-decl-cont . +)
          (inclass . +)
          (incomposition . +)
          (inexpr-class . +)
          (inexpr-statement . +)
          (inextern-lang . +)
          (inher-cont . c-lineup-multi-inher)
          (inher-intro . +)
          (inlambda . c-lineup-inexpr-block)
          (inline-open . +)
          (inmodule . +)
          (knr-argdecl . 0)
          (knr-argdecl-intro . +)
          (label . 2)
          (lambda-intro-cont . +)
          (module-close . 0)
          (module-open . 0)
          (namespace-close . 0)
          (namespace-open . 0)
          (objc-method-args-cont . c-lineup-ObjC-method-args)
          (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
          (objc-method-intro . [0])
          (stream-op . c-lineup-streamop)
          (string . -1000)
          (substatement . +)
          (substatement-label . 2)
          (substatement-open . +)
          (template-args-cont c-lineup-template-args +)
          (topmost-intro-cont . c-lineup-topmost-intro-cont)
       )
     )
  )
