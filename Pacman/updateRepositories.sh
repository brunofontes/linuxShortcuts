BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "${BOLD}$1${NC}"
}

function s() {
   echo -e "$sudoPass\n" | sudo -S $1
   echo
}

echo -n Please type your sudo password:
read -s sudoPass
echo; echo
bold "Pacman-mirrors -g"
s "pacman-mirrors -g"
echo
bold "Updating with PACMAN..."
s "pacman -Syu --color always"
echo
bold "Updating with AURMAN..."
aurman -Su --noedit --noconfirm --color always
echo
bold "Cleaning stuff..."
echo -e "$sudoPass\n" | yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always)
echo
notify-send "Update script has finished!"
