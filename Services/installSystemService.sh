doas rm /etc/systemd/system/$1
doas cp -f $1 /etc/systemd/system/
doas systemctl daemon-reload
doas systemctl status $1
