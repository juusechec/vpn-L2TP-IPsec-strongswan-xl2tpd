# vpn-L2TP-IPsec-strongswan-xl2tpd
Un conjunto de instrucciones y script para conectarse a la VPN 2016 de la Universidad Distrital

##Instalación de dependencias:
strongSwan: Es una completa implementación de IPsec, existe como alternativa a Openswan y Libreswan.
xl2tpd: Es un software con la implementación del protocolo L2TP (Layer 2 Tunneling Protocol)
ppp: Point-to-Point Protocol

```bash
# zypper in strongswan xl2tpd ppp
```
##Configuración de archivos de los servicios:

Se hace respaldo de los archivos originales:
```bash
# cp /etc/ipsec.conf{,.bak}
# cp /etc/ipsec.conf{,.bak}
# cp /etc/xl2tpd/xl2tpd.conf{,.bak}
```

Se modifican los archivos con los respectivos datos de conexión:
```bash
# vim /etc/ipsec.conf
$ cat /etc/ipsec.conf
config setup
        strictcrlpolicy=no
        #charondebug="ike 4, knl 4, cfg 2"    #useful debugs
conn %default
        ikelifetime=1440m
        keylife=60m
        rekeymargin=3m
        keyingtries=1
        keyexchange=ikev1
        authby=xauthpsk
conn vpn-uz
        keyexchange=ikev1
        type=transport
        authby=secret
        ike=3des-sha1-modp1024
        rekey=no
        left=%defaultroute
        leftprotoport=udp/l2tp
        right=200.69.103.48        # IP of your VPN Server
        rightprotoport=udp/l2tp
        auto=add

# vim /etc/ipsec.secrets
$ cat /etc/ipsec.secrets
: PSK "clavePSK"
vpnoas8 : XAUTH "miclavevpn"

# vim /etc/xl2tpd/xl2tpd.conf
;
; This is a minimal sample xl2tpd configuration file for use
; with L2TP over IPsec.
;
; The idea is to provide an L2TP daemon to which remote Windows L2TP/IPsec
; clients connect. In this example, the internal (protected) network 
; is 192.168.1.0/24.  A special IP range within this network is reserved
; for the remote clients: 192.168.1.128/25
; (i.e. 192.168.1.128 ... 192.168.1.254)
;
; The listen-addr parameter can be used if you want to bind the L2TP daemon
; to a specific IP address instead of to all interfaces. For instance,
; you could bind it to the interface of the internal LAN (e.g. 192.168.1.98
; in the example below). Yet another IP address (local ip, e.g. 192.168.1.99)
; will be used by xl2tpd as its address on pppX interfaces.

[global]
; listen-addr = 192.168.1.98
;
; requires openswan-2.5.18 or higher - Also does not yet work in combination
; with kernel mode l2tp as present in linux 2.6.23+
; ipsec saref = yes
; Use refinfo of 22 if using an SAref kernel patch based on openswan 2.6.35 or
;  when using any of the SAref kernel patches for kernels up to 2.6.35.
; saref refinfo = 30
;
; force userspace = yes
;
; debug tunnel = yes

[lns default]
ip range = 192.168.1.128-192.168.1.254
local ip = 192.168.1.99
require chap = yes
refuse pap = yes
require authentication = yes
name = LinuxVPNserver
ppp debug = yes
pppoptfile = /etc/ppp/options.xl2tpd
length bit = yes

;Se agregó solo lo de abajo
[lac vpnoas]
lns = 200.69.103.48
ppp debug = yes
pppoptfile = /etc/ppp/options.l2tpd.client
length bit = yes

# vim /etc/ppp/options.l2tpd.client
$ cat /etc/ppp/options.l2tpd.client
ipcp-accept-local
ipcp-accept-remote
refuse-eap
require-mschap-v2
noccp
noauth
idle 1800
mtu 1410
mru 1410
defaultroute
usepeerdns
debug
lock
connect-delay 5000
name vpnoas8
password mipasswordvpn
```
Se crean los recursos:
```bash
# mkdir -p /var/run/xl2tpd
# touch /var/run/xl2tpd/l2tp-control
```

Con esto como tal se termina la ejecución, hay que realizar la ejecución de conectarVPN.sh y de desconectarVPN.sh para obtener la conexión.

#Referencias
* https://wiki.archlinux.org/index.php/Openswan_L2TP/IPsec_VPN_client_setup
* https://nobrega.com.br/howto-vpn-l2tp-pre-shared-key/
* http://vpninfo.uz.gov.ua/instructions/linux/opensuse/13.2/
* http://www.jasonernst.com/2016/06/21/l2tp-ipsec-vpn-on-ubuntu-16-04/

