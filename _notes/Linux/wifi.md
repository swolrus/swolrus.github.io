---
title: WIFI and Arch Linux
---



> Simple wifi setup and configuration with iwd and systemd-networkd/systemd/resolved

[Simple Wifi Config (IWD/Systemd Networkd)](https://insanity.industries/post/simple-wifi/)

> **TIP**: Make sure the config file ( both .link and .network) starts with a number

## Basic Setup

> First we mask iwd from controlling the interface name to use the udev naming

```bash
sudo ln -s /dev/null /etc/systemd/network/80-iwd.link
```



### IWD Config

```
/etc/iwd/main.conf
```

```bash
[General]
UseDefaultInterface=true

[Network]
NameResolvingService=systemd
EnableIPv6=true

[Scan]
DisableRoamingScan=true
```

Use default interface tells iwd to allow the system to control the interface name meaning it will always configure through networkd correctly.

We want to enable IPv6 as it's disabled as iwd network control doesn't handle well but systemd will and we are using the latter.

Disable periodic only if operating under extremely low SSRI levels to stop it roaming and disconnecting.

### Systemd-networkd Configs

```
/etc/systemd/network/25-wifi.network
```

```bash
[Match]
Type=wlan
WLANInterfaceType=station

[Network]
Description=A wireless network interface device
DHCP=yes
DNS=1.1.1.1#cloudflare-dns.com
DNS=8.8.8.8#dns.google
IPv6PrivacyExtensions=yes
IgnoreCarrierLoss=5s

[DHCPv4]
RouteMetric=20

[IPv6AcceptRA]
RouteMetric=20
```

Here we match all wifi networks (based of the example file provided by networkd)

We want it to manage DHCP addresses and also tell it to ignore carrier loss (incase iwd roams or other minor DC issues).

Also set DNS in this case to cloudflares IPv4 nameservers.

```bash
/etc/systemd/network/20-eth.network
```

```bash
[Match]
Type=ether

[Network]
Description=A wired network interface device
DHCP=yes
DNS=1.1.1.1#cloudflare-dns.com
DNS=1.0.0.1#cloudflare-dns.com
IPv6PrivacyExtensions=yes

[DHCPv4]
RouteMetric=10

[IPv6AcceptRA]
RouteMetric=10
```



## Extra Setup

### Enable Debugging

```shell
 /etc/systemd/system/systemd-networkd.service.d/10-debug.conf
```

```shell
[Service]
Environment=SYSTEMD_LOG_LEVEL=debugEOF
```



> Seeing your debug

```shell
systemctl daemon-reload
systemctl restart systemd-networkd

# view debug
journalctl -b -u systemd-networkd
```



### Changing iwlwifi power settings

**Check if system uses iwlmvm or iwldvm**

```shell
bash lsmod | grep '^iwl.vm'
```

**Create Config**

```
/etc/modprobe.d/iwlwifi.conf
```

```bash
# Sets power_save to off
options iwlwifi power_save=0
# Sets power schem to active (select the one relative to above lsmod output)
options iwlmvm power_scheme=1
options iwldvm force_cam=0
```



### Other Options

> These were not required in my use case but if finding issues with connectivity are driver level settings that may have an effect

In some cases your current iwlwifi  driver already performs better when certain options are toggled, in  which case it doesn't need to be replaced. Which is why you should try  that first.

 You can do that as follows:

 a. Launch a terminal window.
*(You can launch a terminal window like this: [\*Click\*](https://easylinuxtipsproject.blogspot.com/p/terminal.html))*

 b. [Copy/paste](https://easylinuxtipsproject.blogspot.com/p/copy-paste.html) the following blue command line into the terminal (this is one long line, don't chop it up!):

echo "options iwlwifi bt_coex_active=0 swcrypto=1 11n_disable=8" | sudo tee /etc/modprobe.d/iwlwifi-3options.conf

 Press Enter. Type your password when prompted. *In Ubuntu this remains entirely invisible, not even dots will show when you type it, that's normal.* Press Enter again.

 Hereby you achieve three things:

 \- With **bt_coex_active=0** you disable the Bluetooth feature of the WiFi chipset, which sometimes interferes;

 \- With **swcrypto=1** you shift the signal encryption from the hardware (WiFi chipset) to the software, thus taking some load off the WiFi chipset;

 \- With **11n_disable=8** you enable antenna aggregation (Tx AMPDU). Don't be confused because of the option name 11n_disable: when its value is set to 8 it does not disable anything, but ***enables\*** transmission antenna aggregation (Tx AMPDU).

 c. Reboot your computer.

 d. No improvement? Then undo this hack, by removing the file that contains the toggled options, with this terminal command:

sudo rm -v /etc/modprobe.d/iwlwifi-3options.conf

 Reboot your computer and proceed with item 3 below.
