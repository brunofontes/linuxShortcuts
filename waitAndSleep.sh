if [ -z $1 ]; then
  echo "Define how many minutes to wait before sleep"
  echo
  echo "Example: to wait 5 minutes before system suspend, run the following code:"
  echo "waitAndSleep.sh 5"
  echo
  exit
fi

echo "Type your password: "
read -s sudoPass
echo
minutes=$(($1 * 60))
echo "System will sleep in $minutes minutes"
sleep "$minutes" && echo -e "$sudoPass\n" | sudo -S systemctl suspend
