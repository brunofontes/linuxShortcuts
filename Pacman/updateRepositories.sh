BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "${BOLD}$1${NC}"
}

echo -n Please type your sudo password:
read -s sudoPass
echo
echo
bold "Pacman-mirrors -g"
echo
echo "$sudoPass\n" | sudo -nS pacman-mirrors -g
echo
echo
bold "Updating with Pacman..."
echo
echo "$sudoPass\n" | sudo -nS pacman -Syu --color always
echo
echo
bold "Updating with aurman..."
echo
aurman -Su --noedit --noconfirm --color always
echo
echo
bold "Cleaning stuff..."
echo
echo "$sudoPass\n" | yes | (sudo -nS pacman -Rns $(pacman -Qtdq) --color always)
echo
notify-send "Update script has finished!"
