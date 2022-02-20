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

bold "Pacman-mirrors -c"
s "pacman-mirrors -c Brazil"
s "reflector -l 30 -f 10 --save /etc/pacman.d/mirrorlist"

#bold "Updating with YAY..."
s "echo"
yes | yay -Syu --diffmenu --noconfirm --color always

bold "Cleaning stuff..."
s "echo"
yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always)

notify-send "Update script has finished!"
