# keepalived for PiHole

How to run 2 Pi-hole servers in HA (High Availability).

## Installation

1. First we need to install keepalived. Run this command on your PiHoles.

```bash
sudo apt update && sudo apt install keepalived -y
```
After the install we need to enable keepalived. Run this command on both machines.

```bash
sudo systemctl enable keepalived.service
```

### Script to monitor pi-hole ftl service

You can copy the version `chk_ftl` from the git repo

```bash
mkdir /etc/scripts
nano /etc/scripts/chk_ftl
chmod 755 /etc/scripts/chk_ftl
```

## Configuration

2. Now we will add the keepalived configuration on the first Pi-hole machine, the Master/Active server.
You can copy the version `pihole1_keepalived.conf` from the git repo

```bash
sudo nano /etc/keepalived/keepalived.conf
```

3. Now we will add the keepalived configuration on the first Pi-hole machine, the Slave/Backup server(s).
You can copy the versions `pihole2_keepalived.conf` and/or `pihole3_keepalived.conf` from the git repo

```bash
sudo nano /etc/keepalived/keepalived.conf
```

### Explanation of the options:

-**router_id**: should be an unique name, for instance your Pi-hole hostname

-**state**: describes which server is the Master/Active and which is the Backup/Standby server.

-**interface**: change this according to your network interface (e.g. eth0, ens3 etc)

-**virtual_router_id**: this can be any number between 0 and 255. Must be the same on the Master and Backup configs.

-**priority**: the master server should have a higher priority than the backup server.

-**unicast_src_ip**: should be the IP address of the first (Master) server.

-**unicast_peer**: should be the IP address of the second and/or third (Backup) server(s).

-**auth_pass**: create your own (max 8 character) password. Must be the same on the Master and Backup configs.

-**virtual_ipaddress**: this will be the HA IP address.

4. Restart the keepalived service. Run this command on all machines.

```bash
sudo systemctl restart keepalived.service
```

## Running State

5. Change your DHCP server settings to hand out a single (primary) DNS server and use the HA IP address: <virtual_ipaddress>
