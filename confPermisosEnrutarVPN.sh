#!/bin/bash

# rationale: agregar permisos al usuario $USER para realizar las acciones
# de agregar acciones de agregar rutas a la interfaz ppp0 con sudo
file=/etc/sudoers.d/vpnroutes
if sudo test -f $file
then
  echo "El archivo $file ya existe. Nada que hacer."
else

usuario=$USER
  sudo tee $file << EOF
$usuario ALL= NOPASSWD: /usr/sbin/ip route add 10.0.0.0/8 dev ppp0
$usuario ALL= NOPASSWD: /usr/sbin/ip route add 172.30.4.0/23 dev ppp0
EOF

fi
