;; define the seegrid coding style
(defconst my/seegrid-c-style ()
  '("Seegrid C/C++ Programming Style"
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

;; function to load my c-style
(defun my/set-c-ctyle ()
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (c-add-style "seegrid" my/seegrid-c-style t)
  )

;; programming settings
(add-hook 'prog-mode-hook 'spacemacs/toggle-fill-column-indicator)  ;; toggle fill column indicator on
(add-hook 'prog-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))  ;; underscore as part of word
(global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)  ;; increment number
(global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt)  ;; decrement number
(global-git-commit-mode t)  ;; use emacs for git commits
(xterm-mouse-mode -1)  ;; normal copy paste with mouse in terminal
(add-hook 'c-mode-common-hook `my/set-c-ctyle)
(setq whitespace-style (quote (face empty tabs lines-tail trailing)))  ;; display annoying whitespaces
(whitespace-mode 't)  ;; turn on whitespace minor mode

;; setup using org-gcal to use my google calendars
(setq org-gcal-file-alist
    `((,(password-store-get "calendar/seegrid") . "~/org/seegrid.org")
      (,(password-store-get "calendar/family") . "~/org/family.org")
      (,(password-store-get "calendar/personal") . "~/org/personal.org")))
(setq org-gcal-client-id (password-store-get "secrets/org-gcal-client-id"))
(setq org-gcal-client-secret (password-store-get "secrets/org-gcal-client-secret"))
;; org-agenda
(setq org-log-into-drawer t)  ;; log state changes to a drawer
(setq org-agenda-show-outline-path t)  ;; show items path in echo area
(setq org-agenda-log-mode-items (quote (state clocked)))

;; setup org-agenda to keep track of unread messages in slack
(alert-define-style
  'my/alert-style :title
  "Make Org headings for messages I receive - Style"
  :notifier
  (lambda (info)
    (when (get-buffer "slack.org") (with-current-buffer "slack.org" (save-buffer)))
    (write-region
      (s-concat
        "* TODO "
        (plist-get info :title)
        " : "
        (format "%s %s" (plist-get info :title)
                        (s-truncate 127 (plist-get info :message)))
        "\n"
        (format "<%s>" (format-time-string "%Y-%m-%d %H:%M"))
        "\n")
      nil
      "~/org/slack.org"
      t)))
(setq alert-default-style 'message)
(add-to-list 'alert-user-configuration
  '(((:category . "slack")) my/alert-style nil))
;; setup slack
(slack-register-team
  :name "seegrid"
  :default t
  :client-id (password-store-get "email/seegrid-uid")
  :client-secret (password-store-get "email/seegrid-pass")
  :token (password-store-get "secrets/slack-token")
  :full-and-display-names t
  :subscribed-channels '(eng_truck_sw eng_gp8_s8 rock_updates emergency-notices))
(setq slack-prefer-current-team t)  ;; stop asking me which team to use
(evil-define-key 'insert slack-mode-map (kbd ":") nil)  ;; don't insert emoji
(evil-define-key 'insert slack-message-buffer-mode-map (kbd ":") nil)  ;; don't insert emoji
(evil-define-key 'insert slack-thread-message-buffer-mode-map (kbd ":") nil)  ;; don't insert emoji
(slack-start)  ;; start slack when opening emacs
(define-key slack-mode-map (kbd "C-c C-d") #'slack-message-delete)
;; keep my slack status as active
(run-with-timer (* 30 60) nil #'(slack-start))
;; display a nice timestamp in slack
(setq lui-time-stamp-format "[%Y-%m-%d %H:%M]")
(setq lui-time-stamp-only-when-changed-p t)
(setq lui-time-stamp-position 'right)
(add-hook 'focus-out-hook 'my/save-slack)
;; don't display messages or scheduled items if done
(setq org-agenda-skip-scheduled-if-done t)
;; add a way to mark item as done and archive it all in one
(defun my/org-agenda-todo-archive () (interactive) (org-agenda-todo 'done) (org-agenda-archive))
(add-hook 'org-agenda-mode-hook (lambda () (local-set-key (kbd "T") 'my/org-agenda-todo-archive)))

;; org-page
(require 'org-page)
(setq op/repository-directory "~/workspace/erichlf.github.io")
(setq op/site-domain "https://erichlf.github.io")
(setq op/personal-github-link "https://github.com/erichlf")
(setq op/site-main-title "That Stuff I Found Along the Way")
(setq op/site-sub-title "")
(setq op/personal-disqus-shortname (password-store-get "secrets/disqus-user"))
(setq user-full-name "Erich L Foster")
(setq user-mail-address "erichlf@gmail.com")

;; projectile
(setq projectile-project-search-path '("~/workspace"))
(setq org-todo-keywords '((sequence "TODO(t)" "IN PROGRESS(i!)" "STALLED(s!)" "|" "DONE(d!)" "WON'T FIX(w!)")))

;; my functions follow
(defun my/save-slack ()
  "Save slack buffers"
  (interactive)
  (save-excursion
    (dolist (buf ("slack.org_archive" "slack.org"))
      (set-buffer buf)
      (if (and (buffer-file-name) (buffer-modified-p))
        (basic-save-buffer)
        )
      )
    )
  )

(defun my/get-ticket (link)
  "Use a regular expression to determine the ticket in link"
  (save-match-data
    (and (string-match "/\\([A-Za-z]+-[0-9]+\\)\\($\\|\\?\\)" link)
      (match-string 1 link)))
  )

(defun my/ticket-steps (ticketType link)
  "Provides a string that has my standard ticket process"
  (interactive)
  (setq title
    (read-string "TITLE: "))
  (setq header (format "* TODO %s ([[%s][%s]]) [/]
   :PROPERTIES:
   :CUSTOM_ID: %s
   :END:\n" title link (my/get-ticket link) title))
  (setq triage "** TODO Triage\n")
  (setq steps "** TODO Implement
** TODO Code Review
** TODO Branch Test
** TODO Integrate
** TODO Integration Test
** TODO Sign Off")
  (if (equal ticketType "bug")
    (s-concat header triage steps)
    (s-concat header steps)
    )
  )
