(setq chatgpt-repo-path (expand-file-name "chatgpt/" quelpa-build-dir))
(global-set-key (kbd "C-c q") #'chatgpt-query)
(setq python-interpreter "python3")

(setq tramp-terminal-type "tramp")
;; programming settings
(add-hook 'prog-mode-hook 'spacemacs/toggle-fill-column-indicator)  ;; toggle fill column indicator on
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))  ;; underscore as part of word
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)  ;; increment number
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)  ;; decrement number
(setq global-git-commit-mode t)  ;; use emacs for git commits
(xterm-mouse-mode -1)  ;; normal copy paste with mouse in terminal
(add-hook 'c-mode-initialize-hook 'my/c-mode-initialize-hook)  ;; create my c-style
(add-hook 'c-mode-common-hook 'my/c-mode-common-hook)  ;; apply my c-style
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

;; org-templates

(setq ansi-color-names-vector
  ["#d2ceda" "#f2241f" "#67b11d" "#b1951d" "#3a81c3" "#a31db1" "#21b8c7" "#655370"])
(setq evil-want-Y-yank-to-eol nil)
;; (setq fringe-mode 6 nil (fringe))
(setq hl-todo-keyword-faces
  '(("TODO" . "#dc752f")
    ("NEXT" . "#dc752f")
    ("THEM" . "#2d9574")
    ("PROG" . "#4f97d7")
    ("OKAY" . "#4f97d7")
    ("DONT" . "#f2241f")
    ("FAIL" . "#f2241f")
    ("DONE" . "#86dc2f")
    ("NOTE" . "#b1951d")
    ("KLUDGE" . "#b1951d")
    ("HACK" . "#b1951d")
    ("TEMP" . "#b1951d")
    ("FIXME" . "#dc752f")
    ("XXX+" . "#dc752f")
    ("\\?\\?\\?+" . "#dc752f")))
(setq linum-format " %7d ")

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
(setq org-agenda-custom-commands
  '(("n" "Agenda and Main Tasks"
      ((agenda "" nil)
        (tags-todo "LEVEL=2"
          ((org-agenda-prefix-format "%l%l"))))
      nil nil)))
(setq org-agenda-files '("~/org/tasks.org"))
(setq org-capture-templates
  '(("t" "Ticket" entry
      (file+headline "~/org/tasks.org" "Tickets")
      "%(my/ticket-steps \"%x\")")
     ("r" "Code Review" entry
       (file+headline "~/org/tasks.org" "Code Reviews")
       "* TODO [[%x][%(my/get-ticket \"%x\")]]")
     ("T" "Triage" entry
       (file+headline "~/org/tasks.org" "Triage")
       "* TODO [[%x][%(my/get-ticket \"%x\")]]")))
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

;; misc
(setq doc-view-continuous 't)

;; color while compiling
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

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
      (string-match "\\([A-Za-z_-]+-[0-9]+\\)" link)
      (match-string 1 link)
      ))
  )

(defun my/get-pr-num (link)
  "Use a regular expression to determine the code review number in a link"
  (save-match-data
    (and
      (string-match "\\([0-9A-Za-z_.-]+\\)/pulls/\\([0-9]+\\)" link)
      (let ((project (match-string 1 link))
             (pr-number (match-string 2 link)))
        (concat project "#" pr-number)))))

(defun my/get-ticket (link)
  "Use a regular expression to determine the ticket in link"
  (let ((pr-num (my/get-pr-num link)))
    (if (equal pr-num nil)
      (my/get-ticket-num link)
      pr-num)))

(defun my/get-ticket-title (link)
  "Use a regular expression to determine the ticket title in a link"
  (save-match-data
    (and
      (string-match "\\([A-Za-z_-]+-[0-9]+\\)\\/\\(.+\\)" link)
      (subst-char-in-string "-" " " (match-string 2 link))
      )))

(defun my/ticket-steps (link)
  "Provides a string that has my standard ticket process"
  (interactive)
  (setq title
    (my/get-ticket-title link))
  (setq ticket
    (my/get-ticket-num link))
  (setq header (format "\n* TODO %s ([[%s][%s]]) [/]
   :PROPERTIES:
   :CUSTOM_ID: %s
   :ORDERED: t
   :END:\n" title link ticket ticket))
  (setq steps "** TODO Implement
** TODO Code Review
** TODO Branch Test
** TODO Integrate
** TODO Integration Test
** TODO Sign Off\n")
  (s-concat header steps)
  )

;; define the ros coding style
(defconst ros-c-style
  '((c-basic-offset . 2)     ; Guessed value
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
    (template-args-cont c-lineup-template-args +)))
  "ROS C/C++ Programming Style")

;; function to load my c-style
(defun my/c-mode-initialize-hook ()
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (c-add-style "ros-style" ros-c-style t)
  (setq c-default-style "ros-style")
  )

(defun my/c-mode-common-hook (style)
  (c-set-style style)
  )
