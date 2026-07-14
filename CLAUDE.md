# CLAUDE.md

Context for Claude Code sessions in this repo.

## Repository purpose

This repo holds config and tooling for the Pi-hole HA pair. It is **public**, so no secrets in git.

## Deployment topology

- Pi-hole primary: `192.168.53.51` (raspberrypi-pihole-01)
- Pi-hole secondary: `192.168.53.52` (raspberrypi-pihole-02)
- Floating VIP: `192.168.53.53` (keepalived)
- nebula-sync host: `raspberrypi-utility` (192.168.1.248), managed via Portainer GitOps

## Secrets policy

- `.env` files are gitignored — never commit
- Real values stored in 1Password
- `.env.example` files are safe to commit (placeholders only)

## Conventions

- Pin image versions (never `:latest`)
- Atomic commits with descriptive messages
- Deploy before push: verify changes work locally, then commit and push
- Runtime state (logs, db backups, container data) belongs in a gitignored subdirectory or a
  named Docker volume, never committed

## Related repos

- `homelab-utility` — Caddy + Authentik + Portainer server on raspberrypi-utility
- `pi-ntp` — GPS Stratum 1 NTP + monitoring stack
- `adsb`, `BayAreaScanner` — SDR receivers
