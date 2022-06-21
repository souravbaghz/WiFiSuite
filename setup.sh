#!/bin/sh

#if [ "$EUID" -ne 0 ]
#then
#  echo "[!] Installation requires root privilege, please run as root"
#  exit 1
#fi

# Various apt packages
echo "[*] Installing required packages, this may take a while..."
apt-get install -y python3.5 python3-pip aircrack-ng >/dev/null
pip install scapy

echo "[+] INSTALLATION FINISHED."
exit 0
