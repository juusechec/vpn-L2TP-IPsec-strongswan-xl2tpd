#!/bin/bash
#rationale: se valida si es root, de lo contrario, usa sudo para las operaciones
# que requieren privilegios de root
SUDO=''
if [ "$USER" != "root" ]
then
  SUDO='sudo'
fi
$SUDO ip route del 10.20.0.0/16 dev ppp0
$SUDO tee /var/run/xl2tpd/l2tp-control > /dev/null <<< "d vpnoas"
$SUDO ipsec down vpnoas
ip link | grep -i ppp0
ip route | grep -i ppp0
$SUDO systemctl stop strongswan.service
$SUDO systemctl stop xl2tpd.service

