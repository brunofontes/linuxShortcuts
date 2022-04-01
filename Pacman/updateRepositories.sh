BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "\n\n${BOLD}$1${NC}"
}

function s() {
   sudo $*
}

s -v
bold "Pacman-mirrors --continent"
s "pacman-mirrors --continent" 2>/dev/null
# s "pacman-mirrors -c Brazil" 2>/dev/null
s "reflector -l 30 -f 10 --save /etc/pacman.d/mirrorlist" 2>/dev/null

# From now on, exit when any command fails
set -e

s -v
bold "Updating..."
yay -Syu --sudoloop --answerclean none --answerdiff all --answerupgrade all --noremovemake --nobatchinstall --cleanafter

bold "Cleaning stuff..."
s -v
yay -Sc --noconfirm 2>/dev/null
s -v
yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always 2>/dev/null)

s -k
notify-send "Update script has finished!"
