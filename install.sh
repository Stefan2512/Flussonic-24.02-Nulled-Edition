#!/bin/bash

bold=$(tput bold)
underline=$(tput smul)
warn=$(tput setaf 214)
reset=$(tput sgr0)

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "${underline}${warn}${bold}--= Flussonic 24.02 Nulled Private Release =--${reset}"

distro=debian
echo "Distro: $distro"

# Update and install Flussonic
apt-get update
curl -sSf http://apt.flussonic.com/binary/gpg.key > /etc/apt/trusted.gpg.d/flussonic.gpg
echo "deb http://apt.flussonic.com binary/" > /etc/apt/sources.list.d/flussonic.list
apt-get update
apt-get -y install flussonic

# Config default
cat > /etc/flussonic/flussonic.conf <<EOF
http 80;
rtmp 1935;
srt 1234;
iptv;
edit_auth admin admin;
EOF

# Creează systemd service
cat > /etc/systemd/system/flussonic.service <<EOF
[Unit]
Description=Flussonic Streaming Server
After=network.target

[Service]
ExecStart=/opt/flussonic/flussonic
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable flussonic
systemctl start flussonic

# Afiseaza info
local_ip=$(hostname -I | awk '{print $1}')
echo ""
echo "${warn}${bold}Flussonic running at: http://$local_ip:80${reset}"
echo "${warn}${bold}Username: admin | Password: admin${reset}"
echo "${warn}${bold}Crack License: l4|AbOFvyPq7piW0ub_MfFUL2|r6BzpmVPpjgKpn9IunpFp6lLbCZOp3${reset}"
