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
