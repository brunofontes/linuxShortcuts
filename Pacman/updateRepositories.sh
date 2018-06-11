echo
echo Updating with Pacman...
echo
pacman -Syu --color always
echo
yes | pacman -Sc --color always
