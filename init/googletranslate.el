;; 参考 : http://rubikitch.com/2014/12/07/google-translate/

(bundle google-translate)
(bundle popwin)

(use-package popwin
  :config
  (setq display-buffer-function 'popwin:display-buffer)
  (setq popwin:popup-window-position 'bottom)
  )

(use-package google-translate
  :config
  (defvar google-translate-english-chars "[:ascii:]"
	"これらの文字が含まれているときは英語とみなす")
  (defun google-translate-enja-or-jaen (&optional string)
	"regionか、現在のセンテンスを言語自動判別でGoogle翻訳する。"
	(interactive)
	(setq string
		  (cond ((stringp string) string)
				(current-prefix-arg
				 (read-string "Google Translate: "))
				((use-region-p)
				 (buffer-substring (region-beginning) (region-end)))
				(t
				 (save-excursion
				   (let (s)
					 (forward-char 1)
					 (backward-sentence)
					 (setq s (point))
					 (forward-sentence)
					 (buffer-substring s (point)))))))
	(let* ((asciip (string-match
					(format "\\`[%s]+\\'" google-translate-english-chars)
					string)))
	  (run-at-time 0.1 nil 'deactivate-mark)
	  (google-translate-translate
	   (if asciip "en" "ja")
	   (if asciip "ja" "en")
	   string)))
  (global-set-key (kbd "C-c t") 'google-translate-enja-or-jaen)
  ;; google-translate.elの翻訳バッファをポップアップで表示させる
  (push '("*Google Translate*") popwin:special-display-config)
  )

;; C-c t で翻訳
;; 翻訳結果のバッファでC-x o とすると元のバッファに戻り翻訳のバッファは消える
;; C-u C-c t で入力文字を翻訳

