---
title: Miscellaneous Linux Bits
---

## Tutorials
### X11VNC Command Alias
```
alias vnc='x11vnc -auth guess -norepeat -display :0 -scale 3/4 -noxdamage -rfbauth /home/david/.vnc/passwd -rfbport 5900 -geometry 1920x810'
```

[Create desktop shortcut for AppImage](https://www.how2shout.com/linux/how-to-create-desktop-shortcut-for-an-appimage/) - *example below*

```
*.desktop
```

```bash
[Desktop Entry]
Name=ClickUp
Exec=/home/david/.local/share/applications/ClickUp-3.0.6.AppImage
Icon=ClickUp
Type=Application
Categories=Office;Utility;
```

[Packman Remove Leftovers Hook](https://insanity.industries/post/pacman-tracking-leftover-packages/)

## Bash

### Using Chroot to edit system (useful if unbootable/no network)

> First check what partition you will be targetting

```shell
lsblck
```

> Boot of an installation media, mount the root dir and chroot in

```shell
mount <dev/[partition]> /mnt
arch-chroot /mnt
```

Now you can execute commands within the systems file structure (ie use pacman etc)

### Pacman

> Find the package that owns a file

```shell
sudo pacman -Qo <file>
```

> Completely remove a package including config

```shell
sudo pacman -Rns <package>
```

### User Groups

```shell
# Delete a user group
sudo groupdel [OPTIONS] GROUPNAME
# Add a user to groups
# -a means append (wi, -G is group
sudo usermod -a -G <group1[,group2,...]> [user]
```

### System Hacks

```shell
# Stop the screen from turning off
xset s off -dpms
```

### Drivers

[Arch Wiki/Kernel Modules](https://wiki.archlinux.org/title/Kernel_module#Obtaining_information)

```shell
# See available param for a kernel module
modinfo <module>
# Display current config of a kernal module
systool -v -m <module>
```

