#!/bin/bash
#rationale: se valida si es root, de lo contrario, usa sudo para las operaciones
# que requieren privilegios de root
SUDO=''
if [ "$USER" != "root" ]
then
  SUDO='sudo'
fi
$SUDO systemctl start strongswan.service
$SUDO systemctl start xl2tpd.service
# rationale: se espera un momento mientras Started strongSwan IPsec
sleep 2
#$SUDO systemctl status strongswan.service
#$SUDO systemctl status xl2tpd.services
$SUDO ipsec up vpnoas
#echo "c vpnoas" > /var/run/xl2tpd/l2tp-control
$SUDO tee /var/run/xl2tpd/l2tp-control > /dev/null <<< "c vpnoas"
while ! $(ip route | grep -i ppp0 &>/dev/null)
do
 sleep 1
done
ip link | grep -i ppp0
#route add -net 10.20.0.0 netmask 255.255.0.0 dev ppp0
$SUDO ip route add 10.20.0.0/16 dev ppp0
ip route | grep -i ppp0
ip address | grep -i ppp0
