#!/usr/bin/bash
IFACE=$(ip a | grep "br-en" | cut -d ":" -f2 | cut -d " " -f2 | grep br)
ifconfig br-ex 172.18.10.1/24 up
iptables -A POSTROUTING -s 172.18.10.0/24 -o "$IFACE" -j MASQUERADE -t nat
