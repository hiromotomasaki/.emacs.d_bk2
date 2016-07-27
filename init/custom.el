;; 参考 : http://ergoemacs.org/emacs/emacs_custom_system.html
;; 参考 : http://lioon.net/emacs-customize-useful-function

;; M-x customize
;; でGUIで設定できる

;; 例
;; Search 欄で line-number-mode と検索
;; Line Number Mode の Toggleを押してStateを変更し、Applyを押してみて結果を見てよければ使用する。
;; non-nil -> t, nil -> nil (但し、0, 1の場合もあるのでApply and Saveで確認したほうがいい)
;; Apply and Save とすると

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(line-number-mode nil))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )

;; の文字列がinit.elの末尾に追加される。
;; 色々面倒みたいなので、それはしない。

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-x eval-expression
;; > tab-width
;; -> 8
;; > (* 2 tab-width)
;; -> 16

;; tab-width の値の変更
;; ・BAD
;; (set tab-width 4) : tab-width が評価されて 8 という数字に 4 を入れることになる
;; ・GOOD(quoteして値の取り出しを行わないようにする。tab-widthという入れ物に4を入れることになる。)
;; (set (quote tab-width) 4)
;; (set 'tab-width 4) : quoteを'で表現
;; (setq tab-width 4) : さらに'も省略

;; setqは複数変更も可
;; (setq scroll-step 1
;;       scroll-margin 8)
;; or
;; (setq scroll-step 1 scroll-margin 8)

;; シンボルへの関数と変数の格納
;; *scratch*で
;; > global-linum-mode ; C-j
;; -> nil
;; これはglobal-linum-modeが変数として評価されたということ。windowの横に行番号を振らない設定なのでnilだった。
;; > (global-linum-mode t) ; C-j
;; -> t
;; これはglobal-linum-modeが関数として使われたということ。global-linum-modeにtが代入された。

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ******** Emacs/Environment/Mode Line group ******** ;;
;; Toggle line number display in the mode line (Line Number mode).
;; モードラインに行番号表示
(line-number-mode 1)			;表示する
;; (line-number-mode 0)			;表示しない

;; Toggle column number display in the mode line (Column Number mode).
;; モードラインに列番号表示
(column-number-mode 1)			;表示する
;; (column-number-mode 0)			;表示しない

;; Toggle buffer size display in the mode line (Size Indication mode).
;; fileのサイズを表示する
(size-indication-mode 1)		;表示する
;; (size-indication-mode 0)		;表示しない

;; *************************************************** ;;

;; ******** Emacs/Convenience/Linum group ******** ;;
;; Toggle Linum mode in all buffers.
;; 全てのバッファで行数の表示
(global-linum-mode 1)			;表示する
;; (global-linum-mode 0)			;表示しない
;; *********************************************** ;;

;; ******** Emacs/Frames/Fringe group ******** ;;
;; Visually indicate buffer boundaries and scrolling.
;; rightの場合バッファの右にindicatorがでる。
;; (setq-default indicate-buffer-boundaries 'right) ;右
(setq-default indicate-buffer-boundaries 'left) ;左
(setq-default indicate-buffer-boundaries 0) ;無し

;; Visually indicate empty lines after the buffer end.
;; バッファの末尾以降の行を示す
(setq-default indicate-empty-lines t)		;示す
;; (setq-default indicate-empty-lines nil)		;示さない
;; ******************************************* ;;

;; ******** Emacs/Environment/Frames group or Mouse group ******** ;;
;; ******** Emacs/Editing/Mouse group ******** ;;
;; Toggle the tool bar in all graphical frames (Tool Bar mode).
;; ツールバーの表示
;; (tool-bar-mode 1)    ;表示する
(tool-bar-mode 0)    ;表示しない
;; ******************************************* ;;

;; ******** Emacs/Environment/Frames group ******** ;;
;; Toggle display of a menu bar on each frame (Menu Bar mode).
;; メニューバーの表示
;; (menu-bar-mode 1)    ;表示する
(menu-bar-mode 0)    ;表示しない
;; ******************************************* ;;

;; ******** Emacs/Environment/Initialization group ******** ;;
;; Initial message displayed in *scratch* buffer at startup.
;; 初期windowでの*scratch*を表示について
;; (setq initial-scratch-message
;;    ";; This buffer is for notes you don't want to save, and for Lisp evaluation.
;; ;; If you want to create a file, visit that file with C-x C-f,
;; ;; then enter the text in that file's own buffer.

;; ")					;表示あり
(setq initial-scratch-message nil)		;表示なし
;; ******************************************************** ;;

;; ******** Emacs/Environment/Paren Blinking group ******** ;;
;; Non-nil means show matching open-paren when close-paren is inserted.
;; カッコを記述した時の反応
;; (setq blink-matching-paren 'jump)	;「)」対応する「(」にカーソルが一瞬飛ぶ
;; (setq blink-matching-paren nil)		;何もなし
(setq blink-matching-paren t)		;「)」対応する「(」がハイライトされる
;; ******************************************************** ;;

;; *******************Emacs/Files/Backup group********************** ;;
;; Non-nil means make a backup of a file the first time it is saved.
;; fileのバックアップについて
(setq make-backup-files nil)		;無効
;; (setq make-backup-files t)		;有効
;; ******************************************************** ;;

;; *******************Emacs/Files/Auto Save group********************** ;;
;;    Non-nil says by default do auto-saving of every file-visiting buffer.
;; fileのオートセーブについて
(setq auto-save-default nil)		;無効
;; (setq auto-save-default t)		;有効

;; This is used after reading your init file to initialize
;; オートセーブファイル一覧の作成(defaultは .emacs.d/auto-save-listに保存)
(setq auto-save-list-file-prefix nil)	;無効
;; (setq auto-save-list-file-prefix t)	;有効
;; ******************************************************** ;;



;; *************** M-x customize のリストにないもの *************** ;;
(setq inhibit-startup-message t)	;初期windowで*GNY Emacs*を非表示にする
;; (setq inhibit-startup-message nil)	;初期windowで*GNY Emacs*を表示する

(setq inhibit-startup-screen t)		;初期windowで*GNY Emacs*を非表示にする
;; (setq inhibit-startup-screen nil)		;初期windowで*GNY Emacs*を表示する

;; スクロールバーの表示
(set-scroll-bar-mode nil)		;非表示
;; (set-scroll-bar-mode t)			;表示

;; タイトルバーへの情報表示
;; %%b : バッファー名(ファイル名)
;; %%f : フルパス
;; invocation-name : 起動したEmacsのプログラム名
;; emacs-version : emacsのバージョン名
;; system-name : マシン名(ホスト名)
(setq frame-title-format (format "%%b - %%f - %s-%s@%s" invocation-name emacs-version system-name))





;; (defconst user-default-fg "#aaaaaa")
;; (defconst user-default-bg "#1f1f1f")
;; (defconst user-face-alist
;;   `((default   :foreground ,user-default-fg
;;                :background ,user-default-bg)
;;     (region                          :background "#8c8ce8")
;;     (mode-line :foreground "#8fb28f" :background "#3f3f3f" :box nil)
;;     (mode-line-inactive              :background "#5f5f5f" :box nil)
;;     (header-line                     :background "#3f3f3f" :box nil))
;;   "User defined face attributes to override default faces or theme faces.")

;; (defvar zenburn-override-colors-alist
;;   `(("zenburn-fg" . ,user-default-fg)
;;     ("zenburn-bg" . ,user-default-bg)))
;; ;; theme
;; (setq frame-background-mode 'dark)
;; (if (not (and (>= emacs-major-version 24) (>= emacs-minor-version 1)))
;;     (bundle color-theme
;;       (color-theme-initialize)
;;       (color-theme-dark-laptop)
;;       ;; apply user defined faces
;;       (dolist (elt user-face-alist)
;;         (let ((name (car elt)) (attrs (cdr elt)))
;;           (apply #'set-face-attribute `(,name nil ,@attrs))))
;; 	  )
;;   (el-get-lock-unlock 'zenburn-theme)
;;   (bundle zenburn-theme
;;     :url "http://raw.github.com/bbatsov/zenburn-emacs/master/zenburn-theme.el"
;;     (load-theme 'zenburn t)
;;     apply user defined faces
;;     (let* ((class '((class color) (min-colors 89)))
;;            (to-spec #'(lambda (elt) `(,(car elt) ((,class ,(cdr elt))))))
;;            (faces (mapcar to-spec user-face-alist)))
;;       (apply #'custom-theme-set-faces `(user ,@faces)))
;; 	)
;;   )

;; ;; fix for non-frame mode; set face color explicitly
;; (dolist (face '(default mode-line))
;;   (let ((attrs (cdr (assq face user-face-alist))))
;;     (set-face-foreground face (plist-get attrs :foreground))
;;     (set-face-background face (plist-get attrs :background))))

;; (bundle tarao-elisp
;;   :features (mode-line-color)
;;   ;; mode line color
;;   (mode-line-color-mode)
;;   (setq mode-line-color-original (face-background 'mode-line))
;;   (defvar skk-j-mode-line-color "IndianRed4")
;;   (defsubst skk-j-mode-line-color-p ()
;;     (cond
;;      ((and (boundp 'evil-mode) (boundp 'evil-state)
;;            evil-mode (not (eq evil-state 'insert)))
;;       nil)
;;      ((and (boundp 'viper-mode) (boundp 'viper-current-state)
;;            viper-mode (not (eq viper-current-state 'insert-state)))
;;       nil)
;;      ((and (boundp 'skk-j-mode) skk-j-mode))))
;;   (define-mode-line-color (color)
;;     (when (skk-j-mode-line-color-p)
;;       skk-j-mode-line-color))
;;   (defadvice skk-update-modeline (after ad-skk-mode-line-color activate)
;;     (mode-line-color-update))

;;   ;; eof mark
;;   (global-end-mark-mode))

;; ;; use darker comment
;; (defun set-comment-color (color)
;;   (set-face-foreground 'font-lock-comment-delimiter-face color)
;;   (set-face-foreground 'font-lock-comment-face color))
;; (defun darken-comment ()
;;   (interactive)
;;   (set-comment-color "gray32"))
;; (defun lighten-comment ()
;;   (interactive)
;;   (set-comment-color "OrangeRed"))
;; (darken-comment)

;; ;; highlight specific keywords in comments
;; (bundle fic-mode
;;   (add-hook 'prog-mode-hook #'fic-mode) ;; Emacs 24
;;   (add-hook 'cperl-mode-hook #'fic-mode)
;;   (with-eval-after-load-feature 'fic-mode
;;     (push "XXX" fic-highlighted-words)
;;     (dolist (face '(fic-face fic-author-face))
;;       (set-face-foreground face "#d0bf8f")
;;       (set-face-background face "gray40"))))

;; ;; scroll bar
;; (bundle yascroll
;;   (global-yascroll-bar-mode))

;; ;; line-wrap character
;; (require 'disp-table)
;; (defface wrap-face
;;   '((((class color) (min-colors 88) (background dark))
;;      :foreground "aquamarine4")
;;     (((class color) (min-colors 88) (background light))
;;      :foreground "aquamarine2")
;;     (((class color) (min-colors 16))
;;      :foreground "DarkCyan")
;;     (((class color) (min-colors 8))
;;      :foreground "gray")
;;     (((type tty) (class mono))
;;      :inverse-video t))
;;   "Face of the wrap."
;;   :group 'convenience)
;; (set-display-table-slot standard-display-table 'wrap
;;                         (make-glyph-code #xbb 'wrap-face))

;; ;; visualize whitespace
;; (with-eval-after-load-feature 'whitespace
;;   (setq whitespace-global-modes '(not)
;;         whitespace-style '(face tabs tab-mark fw-space-mark lines-tail))
;;   ;; tab
;;   (setcar (nthcdr 2 (assq 'tab-mark whitespace-display-mappings)) [?> ?\t])
;;   (let ((face  'whitespace-tab))
;;     (set-face-background face nil)
;;     (set-face-attribute face nil :foreground "gray30" :strike-through t))
;;   ;; full-width space
;;   (defface full-width-space
;;     '((((class color) (background light)) (:foreground "azure3"))
;;       (((class color) (background dark)) (:foreground "pink4")))
;;     "Face for full-width space"
;;     :group 'whitespace)
;;   (let ((fw-space-mark (make-glyph-code #x25a1 'full-width-space)))
;;     (add-to-list 'whitespace-display-mappings
;;                  `(fw-space-mark ?　 ,(vector fw-space-mark)))))
;; ;; patch
;; (defsubst whitespace-char-or-glyph-code-valid-p (char)
;;   (let ((char (if (consp char) (car char) char)))
;;     (or (< char 256) (characterp char))))
;; (defadvice whitespace-display-vector-p (around improved-version activate)
;;   (let ((i (length vec)))
;;     (when (> i 0)
;;       (while (and (>= (setq i (1- i)) 0)
;;                   (whitespace-char-or-glyph-code-valid-p (aref vec i))))
;;       (setq ad-return-value (< i 0)))))
;; ;; activate
;; (global-whitespace-mode)

;; ;; show trailing whitespace
;; (setq-default show-trailing-whitespace t)
;; (add-hook 'comint-mode-hook #'(lambda() (setq show-trailing-whitespace nil)))

;; ;; 対応する括弧のハイライト
;; (show-paren-mode 1)
;; ;; (setq show-paren-delay 0)
;; ;; (setq show-paren-style 'expression)
;; ;; (set-face-attribute 'show-paren-match-face nil
;; ;;                     :background nil :foreground nil
;; ;;                     :underline "#ffff00" :weight 'extra-bold)

;; ;; hide-show
;; (defun hs-enable ()
;;   (interactive)
;;   (hs-minor-mode)
;;   (local-set-key (kbd "C-c h") 'hs-hide-block)
;;   (local-set-key (kbd "C-c s") 'hs-show-block)
;;   (local-set-key (kbd "C-c l") 'hs-hide-level))


;; ;; *************************************************************** ;;

