# keepalived HA for Pi-hole

Manages the floating VIP `192.168.53.53/24` between the two Pi-hole hosts.

## Topology

- **raspberrypi-hole1** (`192.168.53.51`) — MASTER, priority 150
- **raspberrypi-hole2** (`192.168.53.52`) — BACKUP, priority 145

## Files

- `hole1_keepalived.conf`, `hole2_keepalived.conf` — per-host config, with `auth_pass` redacted
- `chk_ftl` — health probe script, checks that `pihole-FTL` is running; keepalived subtracts 10
  from priority when it exits non-zero, triggering failover
- `README.md` — this file

## Deploy on a fresh host

```bash
# 1. Install
sudo apt update && sudo apt install keepalived -y
sudo systemctl enable keepalived.service

# 2. Health probe
sudo mkdir -p /etc/scripts
sudo cp chk_ftl /etc/scripts/chk_ftl
sudo chmod 755 /etc/scripts/chk_ftl

# 3. Config — copy the right file for this host
sudo cp hole1_keepalived.conf /etc/keepalived/keepalived.conf   # or hole2
# Fill in the real auth_pass from 1Password ("Homelab · keepalived VRRP auth")
sudo nano /etc/keepalived/keepalived.conf

# 4. Start
sudo systemctl restart keepalived.service
sudo systemctl status keepalived.service
```

## Verify failover

Stop `pihole-FTL` on the current MASTER (`sudo systemctl stop pihole-FTL`) and confirm the VIP
migrates to the BACKUP within ~2 seconds:

```bash
ip addr show eth0 | grep 192.168.53.53
```

Restart FTL and the VIP returns to the higher-priority host.

## Notes

- `virtual_router_id 55` must match between the two hosts. Change it if you have another VRRP group
  on the same L2 segment (unlikely on a home network)
- `auth_pass` is limited to 8 characters by keepalived's protocol. Rotate it in 1Password and on
  both hosts if you suspect exposure
- VRRP auth is transmitted as cleartext on the wire; it's a weak anti-tamper measure, not a
  security control. The real defense is that this VLAN is not routable from outside your LAN.
