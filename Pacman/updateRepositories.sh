BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "${BOLD}$1${NC}"
}

function s() {
   sudo $1
   echo
}

s -v
bold "Pacman-mirrors -c"
s "pacman-mirrors -c Brazil"
s "reflector -l 30 -f 10 --save /etc/pacman.d/mirrorlist"

s -v
echo
bold "Updating..."
yay -Syu --sudoloop --noconfirm --nobatchinstall --cleanafter

bold "Cleaning stuff..."
s -v
yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always)
s -v
yay -Sc --noconfirm

s -k
notify-send "Update script has finished!"
