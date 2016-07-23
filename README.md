-# 環境
cat /etc/lsb-release  

DISTRIB_ID=Ubuntu  
DISTRIB_RELEASE=16.04  
DISTRIB_CODENAME=xenial  
DISTRIB_DESCRIPTION="Ubuntu 16.04.1 LTS"  

# emacsの導入
参考 : http://rubikitch.com/2015/03/30/emacs245-news/

## ダウンロード手順
### 1
mkdir local  
cd ~/local  
### 2
wget -O- http://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.xz | tar xJf -  
~/localにemacs-24.5ができる  
cd ~/local/emacs-24.5  
### 3
./configure  
チェックGOOD  
~/local/emacsを作成して  
./configure --prefix=$HOME/local/emacs  
チェックBAD  
エラー箇所をググって解決

私の場合は

configure: error: You seem to be running X, but no X development libraries
were found. You should install the relevant development files for X
and for the toolkit you want, such as Gtk+, Lesstif or Motif. Also make
sure you have development files for image handling, i.e.
tiff, gif, jpeg, png and xpm.
If you are sure you want Emacs compiled without X window support, pass
 --without-x
to configure.

と出た。  
sudo apt install libgtk2.0-dev libtiff5-dev libgif-dev libjpeg-dev libpng12-dev libxpm-dev libncurses-dev  
として無事./configureが通った。 

その後  
make -j4  
make install -j4  
で  
~/local/emacsにbinなどのemacsの実体が完成  
.bashrcにemacsと打てばemacsが動くように  
alias設定をする（alias emacs = ~/local/emacs/bin）  

emacsの起動  
GUIの場合 emacs  
ターミナルの場合 emacs -nw  
emacsのバージョンの確認
emacs --version

日本語マニュアル
https://ayatakesi.github.io/emacs/24.5/emacs.html  

GNU Emacs 24.5.1  
Copyright (C) 2015 Free Software Foundation, Inc.  
GNU Emacs comes with ABSOLUTELY NO WARRANTY.  
You may redistribute copies of Emacs  
under the terms of the GNU General Public License.  
For more information about these matters, see the file named COPYING.  


# emacsの設定
emacsと打つと~/.emacs.dが作成される。  
cd ~/.emacs.d
touch README.md
touch .gitignore  
git init
git add .  
git commit -m 'commit'  
githubでリポジトリを作成  
git remote add origin https://github.com/hiromotomasaki/.emacs.d.git  
git push -u origin master

以後、更新は  
git add .  
git commit -m 'commit'  
git push  

## init.elの作成
参考 : http://tarao.hatenablog.com/entry/20150221/1424518030

cd ~/.emacs.d
内部でシンボリックリンクが貼られたファイルを格納するフォルダ  
mkdir init-loader  
実際のinitファイル群が格納されているフォルダ  
mkdir init  
自分で定義したレシピが格納されているフォルダ  
mkdir recipes  
insertするテンプレートファイルが格納されているフォルダ
mkdir others  
その他  

;; emacs directory  
(when load-file-name  
  (setq user-emacs-directory (file-name-directory load-file-name)))  

(let ((versioned-dir (locate-user-emacs-file (format "v%s" emacs-version))))  
  (setq-default el-get-dir (expand-file-name "el-get" versioned-dir)  
                package-user-dir (expand-file-name "elpa" versioned-dir)))  

;; bundle (an El-Get wrapper)  
(setq-default el-get-emacswiki-base-url  
              "http://raw.github.com/emacsmirror/emacswiki.org/master/")  
(add-to-list 'load-path (expand-file-name "bundle" el-get-dir))  
(unless (require 'bundle nil 'noerror)  
  (with-current-buffer  
      (url-retrieve-synchronously  
       "http://raw.github.com/tarao/bundle-el/master/bundle-install.el")  
    (goto-char (point-max))  
    (eval-print-last-sexp)))  
(add-to-list 'el-get-recipe-path (locate-user-emacs-file "recipes"))  

;; lock the pacakge versions  
(bundle tarao/el-get-lock  
  (el-get-lock)  
  (el-get-lock-unlock 'el-get))  

(bundle with-eval-after-load-feature)  

;; load init files  
(bundle! emacs-jp/init-loader  
  ;; load  
  (setq-default init-loader-show-log-after-init nil  
                init-loader-byte-compile t)  
  (init-loader-load (locate-user-emacs-file "init-loader"))  

  ;; hide compilation results  
  (let ((win (get-buffer-window "*Compile-Log*")))  
    (when win (delete-window win))))  

;; put site-lisp and its subdirectories into load-path  
(when (fboundp 'normal-top-level-add-subdirs-to-load-path)  
  (let* ((dir (locate-user-emacs-file "site-lisp"))  
         (default-directory dir))  
    (when (file-directory-p dir)  
      (add-to-list 'load-path dir)  
      (normal-top-level-add-subdirs-to-load-path))))  

## ここまでのまとめ
.emacs.d内のファイルやディレクトリは  
drwxrwxr-x  8 masakihiromoto masakihiromoto 4096  7月 23 11:41 .git/  (git関係)  
-rw-rw-r--  1 masakihiromoto masakihiromoto  670  7月 23 11:39 .gitignore  (githubに上げないファイル、ディレクトリの設定)  
-rw-rw-r--  1 masakihiromoto masakihiromoto 5314  7月 23 11:53 README.md  (gitのページで下部に出てくる説明)  
drwx------  2 masakihiromoto masakihiromoto 4096  7月 23 11:53 auto-save-list/  (emacsの自動保存)  
-rw-rw-r--  1 masakihiromoto masakihiromoto  297  7月 23 11:52 el-get.lock  (installしたパッケージのバージョン固定)  
drwxrwxr-x  2 masakihiromoto masakihiromoto 4096  7月 23 11:14 init/  (init-loaderで読み込まれる設定ファイル群の管理ディレクトリ)  
drwxrwxr-x  2 masakihiromoto masakihiromoto 4096  7月 23 10:50 init-loader/  (init/内のファイルににシンボリックリンクを貼り、ナンバリングしたもの)
-rw-rw-r--  1 masakihiromoto masakihiromoto 1781  7月 23 11:02 init.el  (ファイル読み込み先、el-get、init-loaderなどの設定)
drwxrwxr-x  2 masakihiromoto masakihiromoto 4096  7月 23 11:13 others/  
drwxrwxr-x  2 masakihiromoto masakihiromoto 4096  7月 23 11:13 recipes/  (http://ja.stackoverflow.com/questions/2157/emacs%E3%83%91%E3%83%83%E3%82%B1%E3%83%BC%E3%82%B8%E7%AE%A1%E7%90%86%E3%81%AE%E8%89%AF%E3%81%84%E6%96%B9%E6%B3%95%E3%81%AB%E3%81%A4%E3%81%84%E3%81%A6, https://github.com/tarao/dotfiles/blob/master/.emacs.d/recipes/auctex.rcp 参照)
drwxrwxr-x  3 masakihiromoto masakihiromoto 4096  7月 23 10:49 v24.5.3/  (el-getでinstallされたファイルの保存先)

のようになった。

.emacs.d内のディレクトリ構造は  

.  
├── auto-save-list  
├── init  
├── init-loader  
├── others  
├── recipes  
└── v24.5.3  
    └── el-get  
        ├── bundle  
        ├── bundle-init  
        ├── el-get  
        │   ├── logo  
        │   ├── methods  
        │   ├── recipes  
        │   │   └── emacswiki  
        │   └── test  
        │       ├── issues  
        │       └── pkgs  
        ├── el-get-lock  
        ├── init-loader  
        └── with-eval-after-load-feature  
  
20 directories  

