BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "${BOLD}$1${NC}"
}

function s() {
   echo -e "$sudoPass\n" | sudo -S $1
   echo
}

sudo -k
echo -n Please type your sudo password:
read -s sudoPass
echo
s "echo '**********'"

bold "Pacman-mirrors -g"
s "pacman-mirrors -g"

bold "Updating with PACMAN..."
s "pacman -Syu --color always"

bold "Updating with AURMAN..."
aurman -Su --noedit --noconfirm --color always

bold "Cleaning stuff..."
echo -e "$sudoPass\n" | yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always)

notify-send "Update script has finished!"
