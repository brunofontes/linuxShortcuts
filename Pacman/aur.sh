sudo echo 
cd ~/Downloads
git clone https://aur.archlinux.org/"$1".git
cd "$1"
sudo yes | makepkg -si && cd ..; rm -rf ""$1""
notify-send """$1"" installed!"
