# pi-pihole

[![Release version](https://img.shields.io/github/v/release/jj358mhz/pi-pihole)](https://github.com/jj358mhz/pi-pihole/releases/latest)

Configuration and utilities for the Pi-hole HA pair on my home network.

## Architecture

Two Pi-hole v6 instances behind a keepalived VIP:

- **Primary:** `192.168.53.51` (raspberrypi-pihole-01)
- **Secondary:** `192.168.53.52` (raspberrypi-pihole-02)
- **VIP:** `192.168.53.53` — advertised via keepalived, floats to whichever host is healthy

Downstream clients configure DNS as `192.168.53.53`. UDM Pro SE DNAT rules on the IoT/Security/Corp
VLANs redirect all outbound NTP traffic to `raspberrypi-ntp` (see the `pi-ntp` repo).

## Contents

### `nebula-sync/`

Portainer-managed stack running [lovelaze/nebula-sync](https://github.com/lovelaze/nebula-sync).
Every minute it Teleporter-exports the primary Pi-hole and imports into the secondary, keeping
their config identical.

- **Host:** `raspberrypi-utility` (192.168.1.248)
- **Portainer stack:** https://portainer.telcomjj.com → Stacks → nebula-sync (GitOps polling)
- **Env vars:** see `nebula-sync/.env.example`; real values in 1Password under
  "Homelab · nebula-sync stack"

### `keepalived/`

VIP failover config for the HA pair. Manually installed on both Pi-hole hosts at
`/etc/keepalived/keepalived.conf`.

### `up_unbound.sh`

Bootstrap script for Unbound (recursive DNS) on a new Pi-hole host.
