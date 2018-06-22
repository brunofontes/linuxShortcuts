if [ -z "$2" ]; then
	echo -n Sudo Password:
	read -s sudoPass
else
	sudoPass=$2
fi
mkdir -p ~/AUR
cd ~/AUR
git clone https://aur.archlinux.org/"$1".git
cd "$1"
echo "cd --; rm -rf ~/AUR/""$1""" > clean.sh
echo "$sudoPass" | sudo -S yes | makepkg -si && source clean.sh
