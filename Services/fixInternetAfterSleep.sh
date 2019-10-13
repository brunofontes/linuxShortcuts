sleep 30
if ! ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  modProbeNumber=$(sudo dmesg | grep -m1 "enp1s0: link down" | awk '{if ($2 ~ /r[0-9].*/) { col=$2 } else { col=$3 }; gsub(":", "", col); print col }')
  sudo modprobe -r "$modProbeNumber" && sleep 10 && sudo modprobe "$modProbeNumber"
fi
