(bundle undo-tree)
(use-package undo-tree
  ;; C-x u でundo-tree
  ;; M-/ でredo
  ;; undo-treeのバッファでqで終了. dで差分表示
  :config 
  (global-undo-tree-mode 1)
  (global-set-key (kbd "M-/") 'undo-tree-redo)
  )
