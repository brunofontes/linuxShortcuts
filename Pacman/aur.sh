sudo echo 
mkdir -p ~/AUR
cd ~/AUR
git clone https://aur.archlinux.org/"$1".git
cd "$1"
echo "cd ..; rm -rf ""$1""" > clean.sh
sudo yes | makepkg -si && ./clean.sh && notify-send """$1"" installed!"
