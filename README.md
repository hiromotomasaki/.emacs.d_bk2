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
参考 : http://biwakonbu.com/?p=555  
## el-getの導入(パッケージ管理)
init.elの先頭に

;; load-path で ~/.emacs.d と書かなくてよくなる  
(when load-file-name  
  (setq user-emacs-directory (file-name-directory load-file-name)))  

;; el-getの設定(El-Getがインストールされていればそれを有効化し, そうでなければGitHubからダウンロードしてインストールする)  
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))  
(unless (require 'el-get nil 'noerror)  
  (with-current-buffer  
      (url-retrieve-synchronously  
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")  
    (goto-char (point-max))  
    (eval-print-last-sexp)))  

と書く。

## init-loaderの導入

