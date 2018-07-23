echo -n Please type your sudo password:
read -s sudoPass
echo;
echo "$sudoPass" | sudo -S pacman-mirrors -g
echo
echo Updating with Pacman...
echo
echo "$sudoPass" | sudo -S pacman -Syu --color always
echo;
aurman -Su --color always
echo;
echo "$sudoPass" | yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always)
notify-send "Update script has finished!"
