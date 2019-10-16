#!/bin/bash
#
#***************************************************************************
# snapmanager.sh
#
# Shell script for Proxmox snapshop management
#
# Copyright (C) 2019 Wanderson S FrÃ³es (Zero21)
#
# E-mail: zero21rj@outlook.com
#
# This file may be distributed under the terms of the GNU General
# Public License.
#
# Licenca: GPL
#
# Instal this script in /usr/sbin/
#
# Use: snapmanager <vmid> <vmsnapname> <retention number>
# <vmid> number of your vm image
# <vmsnapname> name that your snapshot
# <rettention numer> number of holds until deletion of oldest
#
# Ex.:  snapmanager.sh 100 VM-100 5
#
# in CRON
# crontab -e
# 08 11 * * * /usr/sbin/snapmanager.sh 100 VM100 4
#
# Version 1.2
#
#***************************************************************************

vmid=$1
vmname=$2
ret=$3
dt=$(which date)
day=$($dt +%d)
month=$($dt +%m)
year=$($dt +%Y)
time=$($dt +%H%M)
qmname=$vmname$year$month$day$time


if [ $# -lt 1 ] || [ -z $vmid ] || [ -z $vmname ] || [ -z $ret ]; then
  clear
  echo "Snap Manager 1.1"
  echo -e "Use: snamanager <vmid> <vmsnapname>\nEx.:  snapmanager.sh 100 VM-100 5"
  echo
  exit 1
fi

/usr/sbin/qm snapshot $vmid $qmname --vmstate true

totalsnaps=$(ls /dev/pve/vm-$vmid-state* | wc -l)
if [ $totalsnaps -ge $ret ]; then
  snapfiles=$(ls -lrt /dev/pve/vm-$vmid-state* | awk '{print $9}' | cut -c 23-100)
  for snaps in $snapfiles; do
    /usr/sbin/qm delsnapshot $vmid $snaps
    break
  done
fi

#
# End Of File
# by Zero21
#

