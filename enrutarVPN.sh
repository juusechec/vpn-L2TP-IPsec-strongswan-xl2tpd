#!/bin/bash
sudo ip route add 10.0.0.0/8 dev ppp0
sudo ip route add 172.30.4.0/23 dev ppp0
