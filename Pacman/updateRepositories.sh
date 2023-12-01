BOLD='\e[91m'
NC='\e[39m'

function bold() {
   echo -e "\n\n${BOLD}$1${NC}"
}

function s() {
   sudo $*
}

# From now on, exit when any command fails
set -e

s -v
bold "Updating..."
s nice --adjustment=18 ionice -c 3 pacman -Syu
nice --adjustment=18 ionice -c 3 yay -Syu --sudoloop --answerclean none --answerdiff all --answerupgrade all --noremovemake --norebuild --noredownload --nobatchinstall --cleanafter

bold "Cleaning stuff..."
s -v
yay -Sc --noconfirm 2>/dev/null
s -v
yay -Yc 2>/dev/null
s -v
yes | (sudo -S pacman -Rns $(pacman -Qtdq) --color always 2>/dev/null)

s -k

s /home/bruno/pacnew.sh
notify-send "Update script has finished!"
