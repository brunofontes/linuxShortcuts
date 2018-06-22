echo -n Please type your sudo password:
read -s sudoPass
echo;
check_pkgversion() {
	newver=$(curl -s "https://aur.archlinux.org/rpc.php?type=info&arg=$1" | awk -F : '{print $10}' | awk -F , '{print $1}' | sed 's/"//g')
	currentver=$(pacman -Qi $1 | awk '{print $3}' | head -n 2 | tail -n 1)
	if [[ $newver != $currentver ]]; then
		echo 1
	fi
}

echo
echo Updating with Pacman...
echo
echo "$sudoPass" | sudo -S pacman -Syu --color always
echo
aurpkgs=$(pacman -Qm | awk '{print $1}')
for line in $aurpkgs
do
	vcheck=$(check_pkgversion $line)
	if [[ $vcheck == 1 ]]; then
		source ~/aur.sh "$line" "$sudoPass"
	fi
done
echo "$sudoPass" | yes | (sudo -S pacman -Sc --color always)
notify-send "Update script has finished!"
