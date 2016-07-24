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
;; *************************************************************** ;;


