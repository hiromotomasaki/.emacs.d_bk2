;;リージョン内の行数と文字数をモードラインに表示する
;; http://d.hatena.ne.jp/sonota88/20110224/1298557375
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ""))

(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; ********** テーマ ********** ;;
(setq frame-title-format
      '("" invocation-name "-" emacs-version "@" short-hostname ": %b"))

(defconst user-default-fg "#aaaaaa")
(defconst user-default-bg "#1f1f1f")
(defconst user-face-alist
  `((default   :foreground ,user-default-fg
               :background ,user-default-bg)
    (region                          :background "#8c8ce8")
    (mode-line :foreground "#8fb28f" :background "#3f3f3f" :box nil)
    (mode-line-inactive              :background "#5f5f5f" :box nil)
    (header-line                     :background "#3f3f3f" :box nil))
  "User defined face attributes to override default faces or theme faces.")

(defvar zenburn-override-colors-alist
  `(("zenburn-fg" . ,user-default-fg)
    ("zenburn-bg" . ,user-default-bg)))
;; theme

(setq frame-background-mode 'dark)
(if (not (and (>= emacs-major-version 24) (>= emacs-minor-version 1)))
    (bundle color-theme
      (color-theme-initialize)
      (color-theme-dark-laptop)
      ;; apply user defined faces
      (dolist (elt user-face-alist)
        (let ((name (car elt)) (attrs (cdr elt)))
          (apply #'set-face-attribute `(,name nil ,@attrs)))))
  (el-get-lock-unlock 'zenburn-theme)
  (bundle zenburn-theme
    :url "http://raw.github.com/bbatsov/zenburn-emacs/master/zenburn-theme.el"
    (load-theme 'zenburn t)
    ;; apply user defined faces
    ;; face : フォント，前景色，背景色，下線の有無といった，スクリーン上でのテキストの表示に関する属性の集合．
    (let* ((class '((class color) (min-colors 89)))
           (to-spec #'(lambda (elt) `(,(car elt) ((,class ,(cdr elt))))))
           (faces (mapcar to-spec user-face-alist)))
      (apply #'custom-theme-set-faces `(user ,@faces)))))


;; fix for non-frame mode; set face color explicitly
(dolist (face '(default mode-line))
  (let ((attrs (cdr (assq face user-face-alist))))
    (set-face-foreground face (plist-get attrs :foreground))
    (set-face-background face (plist-get attrs :background))))


(bundle tarao-elisp
  :features (mode-line-color)
  ;; mode line color
  (mode-line-color-mode)
  (setq mode-line-color-original (face-background 'mode-line))
  (defvar skk-j-mode-line-color "IndianRed4")
  (defsubst skk-j-mode-line-color-p ()
    (cond
     ((and (boundp 'evil-mode) (boundp 'evil-state)
           evil-mode (not (eq evil-state 'insert)))
      nil)
     ((and (boundp 'viper-mode) (boundp 'viper-current-state)
           viper-mode (not (eq viper-current-state 'insert-state)))
      nil)
     ((and (boundp 'skk-j-mode) skk-j-mode))))
  (define-mode-line-color (color)
    (when (skk-j-mode-line-color-p)
      skk-j-mode-line-color))
  (defadvice skk-update-modeline (after ad-skk-mode-line-color activate)
    (mode-line-color-update))

  ;; eof mark
  (global-end-mark-mode))

;; use darker comment
(defun set-comment-color (color)
  (set-face-foreground 'font-lock-comment-delimiter-face color)
  (set-face-foreground 'font-lock-comment-face color))
(defun darken-comment ()
  (interactive)
  (set-comment-color "gray32"))
(defun lighten-comment ()
  (interactive)
  (set-comment-color "OrangeRed"))
(darken-comment)

;; highlight specific keywords in comments
(bundle fic-mode
  (add-hook 'prog-mode-hook #'fic-mode) ;; Emacs 24
  (add-hook 'cperl-mode-hook #'fic-mode)
  (with-eval-after-load-feature 'fic-mode
    (push "XXX" fic-highlighted-words)
    (dolist (face '(fic-face fic-author-face))
      (set-face-foreground face "#d0bf8f")
      (set-face-background face "gray40"))))

;; scroll bar
(bundle yascroll
  (global-yascroll-bar-mode))

;; line-wrap character
(use-package disp-table
  :config
(defface wrap-face
  '((((class color) (min-colors 88) (background dark))
     :foreground "aquamarine4")
    (((class color) (min-colors 88) (background light))
     :foreground "aquamarine2")
    (((class color) (min-colors 16))
     :foreground "DarkCyan")
    (((class color) (min-colors 8))
     :foreground "gray")
    (((type tty) (class mono))
     :inverse-video t))
  "Face of the wrap."
  :group 'convenience)
(set-display-table-slot standard-display-table 'wrap
                        (make-glyph-code #xbb 'wrap-face))
  )

;; visualize whitespace
(with-eval-after-load-feature 'whitespace
  (setq whitespace-global-modes '(not)
        whitespace-style '(face tabs tab-mark fw-space-mark lines-tail))
  ;; tab
  (setcar (nthcdr 2 (assq 'tab-mark whitespace-display-mappings)) [?> ?\t])
  (let ((face  'whitespace-tab))
    (set-face-background face nil)
    (set-face-attribute face nil :foreground "gray30" :strike-through t))
  ;; full-width space
  (defface full-width-space
    '((((class color) (background light)) (:foreground "azure3"))
      (((class color) (background dark)) (:foreground "pink4")))
    "Face for full-width space"
    :group 'whitespace)
  (let ((fw-space-mark (make-glyph-code #x25a1 'full-width-space)))
    (add-to-list 'whitespace-display-mappings
                 `(fw-space-mark ?　 ,(vector fw-space-mark)))))

;; patch
(defsubst whitespace-char-or-glyph-code-valid-p (char)
  (let ((char (if (consp char) (car char) char)))
    (or (< char 256) (characterp char))))
(defadvice whitespace-display-vector-p (around improved-version activate)
  (let ((i (length vec)))
    (when (> i 0)
      (while (and (>= (setq i (1- i)) 0)
                  (whitespace-char-or-glyph-code-valid-p (aref vec i))))
      (setq ad-return-value (< i 0)))))
;; activate
(global-whitespace-mode)

;; show trailing whitespace
(setq-default show-trailing-whitespace t)
(add-hook 'comint-mode-hook #'(lambda() (setq show-trailing-whitespace nil)))

;; ;; 編集行をハイライト
;; (global-hl-line-mode)

;; parenthesis
(show-paren-mode 1)
(defvar show-paren-delay 0)		;setqだけだとwarningが出る
(defvar show-paren-style 'expression)	;setqだけだとwarningが出る
(setq show-paren-delay 0)
(setq show-paren-style 'expression)

(set-face-attribute 'show-paren-match-face nil
		    :background user-default-bg
                    :underline "#ffff00")


;; (show-paren-mode 1)
;; (defvar show-paren-delay 0)
;; (defvar show-paren-style 'mixed)
;; ;; (use-package paren 
;; ;;    :init (show-paren-mode) 
;; ;;    :config (setq show-paren-when-point-inside-paren nil 
;; ;;                  show-paren-when-point-in-periphery t)) 




;; (show-paren-mode 1)
;; (defvar show-paren-delay 0)
;; (defvar show-paren-style 'mixed)
;; ;; (set-face-attribute 'show-paren-match-face nil
;; ;;                     :background nil :foreground nil
;; ;;                     :underline "#ffff00" :weight 'extra-bold)


