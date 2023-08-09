---
title: Bash (Linux) Introduction
---



## Commands

[[Bash Commands]]

## The File System
### /bin
-	Binary executables
-	ls, ping, grep etc.
-	Symlink to /usr/bin

### /sbin
-	contains system binaries
-	reboot, fdisk, ifconfig etc

### /etc
-	config files and scripts for services
-	passwd/shadow files containing password/user info

### /dev
-	device files (interface with attached physical devices)

### /proc
-	system info storage eg uptime

### /var
-	does not survive reboots
-	**/var/logs**
	-	logs
-	**/var/spool**
	-	printing
-	**/var/tmp**
	-	run prog out of, does not survive reboot
