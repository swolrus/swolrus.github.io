---
title: Setting External Monitor Brightness
---

## DDC/CI
[DDC/CI](https://en.wikipedia.org/wiki/Display_Data_Channel#DDC.2FCI "wikipedia:Display Data Channel") (Display Data Channel Command Interface) can be used to communicate with external monitors implementing MCCS (Monitor Control Command Set) over I2C. DDC can control brightness, contrast, inputs, etc on supported monitors. Settings available via the OSD (On-Screen Display) panel can usually also be managed via DDC. The [kernel module](https://wiki.archlinux.org/title/Kernel_module "Kernel module") `i2c-dev` may need to be loaded if the `/dev/i2c-*` devices do not exist.

[ddcutil](https://archlinux.org/packages/?name=ddcutil) can be used to query and set brightness settings:

## Usage
**Check Control Exists**
```bash
# COMMAND
ddcutil capabilities | grep "Feature: 10"
# OUTPUT
	Feature: 10 (Brightness)
```
**Check Range**
```bash
# COMMAND
ddcutil getvcp 10
# OUTPUT
OUTPUT: VCP code 0x10 (Brightness                    ): current value =    60, max value =   100
```
**Set Brightness**
```bash
ddcutil setvcp 10 70
```

## Utilities
Alternatively, one may use [ddcci-driver-linux-dkms](https://aur.archlinux.org/packages/ddcci-driver-linux-dkms/)AUR to expose external monitors in sysfs. Then, after loading the `ddcci` [kernel module](https://wiki.archlinux.org/title/Kernel_module "Kernel module"), one can use any [backlight utility](https://wiki.archlinux.org/title/backlight#Backlight_utilities).

## Aliases for Ease of Use
```bash
~/.bashrc

alias dim='sudo ddcutil setvcp 10 10'
alias mid='sudo ddcutil setvcp 10 65'
alias bright='sudo ddcutil setvcp 10 90'
```
