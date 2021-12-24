#/bin/sh

sleep 10s
wifi=$(iwconfig 2>/dev/null | grep Quasimodo)
if [[ -z $wifi ]]; then
    echo "Starting OPEN VPN"
    /usr/bin/systemctl restart openvpn-client@archerc6.service
else
    echo "At home, no VPN for you"
    /usr/bin/systemctl stop openvpn-client@archerc6.service
fi
