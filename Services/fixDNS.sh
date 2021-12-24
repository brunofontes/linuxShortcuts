#Aparentemente tem um momento em que quando o dns não está funcionando o dig também não retorna nada, então para o script a conexão está funcionando
source /home/bruno/enableDongleWifi.sh

function isDNSWorking() {
    return $(dig brunofontes.net | grep "ANSWER: 0")
}
logfile="/var/log/bfontes"

sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Checking if DNS is working" | sudo tee -a "$logfile"
dnsWorking=`isDNSWorking`
echo "$dnsWorking"

if [ "$dnsWorking" ]; then
    sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - DNS not working, hour may be wrong. Trying to fix..." | sudo tee -a "$logfile"
    sudo chattr -i /etc/resolv.conf
    sudo sed -i 's/127.0.0.2/9.9.9.9/' /etc/resolv.conf 2>>"$logfile"
    sudo chattr +i /etc/resolv.conf

    sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Forcing time to sync" | sudo tee -a "$logfile"
    sudo chronyc online 2>"$logfile"
    sudo chronyc -a 'burst 4/4'
    i=0
    while [ "$dnsWorking" -a $i -le 4 ]; do
        sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Waiting..." | sudo tee -a "$logfile"
        sleep 20
        dnsWorking=`isDNSWorking`
        i=$(( "$i" + 1 ))
    done

    if [ -z "$dnsWorking" ]; then
        sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - FIXED!" | sudo tee -a "$logfile"
    else
        sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Script has failed..." | sudo tee -a "$logfile"
        sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Fixing DNS script has failed. More details on $logfile" | sudo tee -a ~/.log_error
    fi
    sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Configuring DNS servers back." | sudo tee -a "$logfile"
    sudo chattr -i /etc/resolv.conf
    sudo sed -i 's/9.9.9.9/127.0.0.2/' /etc/resolv.conf
    sudo chattr +i /etc/resolv.conf
fi
sudo echo "$(date +"%Y-%m-%d %H:%M:%S") - Done" | sudo tee -a "$logfile"
