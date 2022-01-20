
#!/bin/sh

iptables -t nat -A PREROUTING -p tcp --dport 53 -j DNAT --to 10.10.10.10
iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to 10.10.10.10

iptables -t nat -A POSTROUTING -m iprange --src-range 192.168.1.1-192.168.1.254 -j MASQUERADE
iptables -t nat -A POSTROUTING -m iprange --src-range 192.168.10.1-192.168.10.254 -j MASQUERADE
iptables -t nat -A POSTROUTING -m iprange --src-range 192.168.20.1-192.168.20.254 -j MASQUERADE
iptables -t nat -A POSTROUTING -m iprange --src-range 192.168.30.1-192.168.30.254 -j MASQUERADE
iptables -t nat -A POSTROUTING -m iprange --src-range 192.168.40.1-192.168.40.254 -j MASQUERADE

iptables -t nat -A PREROUTING ! -s 10.10.10.10 -p tcp --dport 53 -j DNAT --to 10.10.10.10
iptables -t nat -A PREROUTING ! -s 10.10.10.10 -p udp --dport 53 -j DNAT --to 10.10.10.10
iptables -t nat -A POSTROUTING -m iprange --src-range 10.10.10.1-10.10.10.254 -j MASQUERADE