# 環境
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
      