#!/bin/bash

set -e
set -u
export LANG=C
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

bold=$(tput bold)
underline=$(tput smul)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

echo "    ________                            _         _   __      ____         __"
echo "   / ____/ /_  ________________  ____  (_)____   / | / /_  __/ / /__  ____/ /"
echo "  / /_  / / / / / ___/ ___/ __ \/ __ \/ / ___/  /  |/ / / / / / / _ \/ __  / "
echo " / __/ / / /_/ (__  |__  ) /_/ / / / / / /__   / /|  / /_/ / / /  __/ /_/ /  "
echo "/_/   /_/\__,_/____/____/\____/_/ /_/_/\___/  /_/ |_/\__,_/_/_/\___/\__,_/   "
echo "  "
echo "${underline}${warn}${bold}--= Flussonic 24.02 Nulled Private Release =--${reset}"
echo "  "

# Instalare Flussonic oficial
curl -sSf https://flussonic.com/public/install.sh | sh

# Instalare pachet .deb nulled din directorul resources
cd resources/
dpkg -i *.deb

# Config implicit
cat > /etc/flussonic/flussonic.conf <<EOF
http 80;
rtmp 1935;
srt 1234;
pulsedb /var/lib/flussonic;
session_log /var/lib/flussonic;
edit_auth admin admin;

iptv;
EOF

# Pornire serviciu
service flussonic start || true
/etc/init.d/flussonic restart || true

# Info server
local_ip=$(hostname -I | awk '{print $1}')
http_port=80
rtmp_port=1935
srt_port=1234

echo "  "
echo "${warn}${bold}Installation Complete!${reset}"
echo "${warn}${bold}Local IP: $local_ip${reset}"
echo "${warn}${bold}HTTP Port: $http_port${reset}"
echo "${warn}${bold}RTMP Port: $rtmp_port${reset}"
echo "${warn}${bold}SRT Port: $srt_port${reset}"
echo "${warn}${bold}Web Panel: http://$local_ip:$http_port${reset}"
echo "${warn}${bold}Username: admin${reset}"
echo "${warn}${bold}Password: admin${reset}"
echo "${warn}${bold}Copy License Key: l4|AbOFvyPq7piW0ub_MfFUL2|r6BzpmVPpjgKpn9IunpFp6lLbCZOp3${reset}"
