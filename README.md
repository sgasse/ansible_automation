# Ansible Automation

This repository contains roles and playbooks to automate server configuration with ansible. Configuration files with sensitive data is not checked into the repo, but dummy files are given to illustrate how the roles can be used.

Note that this repository is still in an alpha state.

## User Account Management
The user accounts on servers are updated with the playbook `update_accounts.yml`. The playbook will look at the inventory file and create admins and developers (without `sudo`) according to the usernames specified for the host group. This way, we only have to specify who is admin or developer for a whole group of servers and the accounts are updated accordingly.

To avoid having several sources of truth, the user data in terms of `uid`, password hash and `authorized_keys` is loaded from a separate file. This file can also be encrypted with `ansible-vault` and stored separately from this repository. This avoids having to update the repository just to change a password hash and keeps sensitive information separate.

### Generating a Linux password hash
Every user needs to create the `sha-512` hash of their password.
```bash
# Make hashing tool available
sudo apt install whois

# Type password to the prompt
mkpasswd --method=sha-512
```

### Generating a secure SSH key
RSA keys are only considered secure if they are at least 3000 bits long. Therefore, we use modern SSH key pairs based on elliptic curve algorithms.

A private key to an admin account should always be password protected. If this file is stolen, the security will rely on how hard it is to brute-force. To make it harder for attackers, we can use many hashing rounds in the password check, minimally increasing the decrypt time (still in the milliseconds) while greatly increasing security (`-a 100` option).
```bash
ssh-keygen -t ed25519 -a 100
```

# Raspberry Pi Setup
A part of this repository is used to setup new Raspberry Pis. The section below contains some information on how to do that.

## First setup of headless raspberry

Activate SSH on boot by placing a file named `ssh` into the boot folder on the SD card.

Configure wifi by placing `wpa_supplicant.conf` file in the boot folder on the SD card.
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
country=<Insert 2 letter ISO 3166-1 country code here>
update_config=1

network={
 ssid="<Name of your wireless LAN>"
 psk="<Password for your wireless LAN>"
}
```

Login
```
# Find all devices in your subnet
nmap -sP 192.168.0.0/24

# Default password: `raspberry`
ssh pi@<ip-of-pi>
```

Check connectivity
```bash
# -k option requires the package `sshpass`
ansible -m ping -u pi -k -i inventories/production.yml all
```

Run ansible script with SSH password login for the first run
```bash
ansible-playbook -u pi -k -i inventories/production.yml update_accounts.yml
```