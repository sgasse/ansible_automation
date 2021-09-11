

### Generating a Linux password hash
```bash
# Make hashing tool available
sudo apt install whois

# Type password to the prompt
mkpasswd --method=sha-512
```


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