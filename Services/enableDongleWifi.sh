#/bin/sh

dongleWifi=$(ip link | grep wlp | grep DOWN | awk '{ print $2 }' | tr -d :)
[ "$dongleWifi" ] && wpa_supplicant -B -i "$dongleWifi" -c /etc/wpa_supplicant/wpa_supplicant-wlan0.conf
