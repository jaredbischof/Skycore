#!/bin/bash
set -x

cat /proc/mdstat
set -e

#create /dev/sda1
echo -e -n "n\\n1\\n\\n\\n\\nw\\ny\\n" | gdisk /dev/sda
#create /dev/sdb1
echo -e -n "n\\n1\\n\\n\\n\\nw\\ny\\n" | gdisk /dev/sdb
sleep 3

# wipe /dev/sda1 /dev/sdb1 to avoid detection of previous RAID
for device in /dev/sda1 /dev/sdb1 ; do 
 dd if=/dev/zero of=${device} bs=1M count=1 ;
 # wipe last megabyte to get rid of RAID
 # 2048 is 1M/512bytes (getsz returns nuber of 512blocks)
 dd if=/dev/zero of=${device} bs=512 count=2048 seek=$((`blockdev --getsz ${device}` - 2048)) ;
done

sleep 3

#create RAID1
mdadm --create --metadata=0.90 --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sda1 /dev/sdb1
sleep 5


# create swap partition
#echo -e -n "2\\no\\ny\\nn\\n1\\n\\n+200G\\n8200\\nw\\ny\\n" | gdisk /dev/md0
echo -e -n "n\\n1\\n\\n+200G\\n8200\\nw\\ny\\n" | gdisk /dev/md0

sleep 3 # wait before you create the next one, issue in scripts

fdisk -l

#create data partition
echo -e -n "n\\n2\\n\\n\\n\\nw\\ny\\n" | gdisk /dev/md0
sleep 3

fdisk -l

/usr/sbin/wipefs -f /dev/md0p1
/usr/sbin/wipefs -f /dev/md0p2

fdisk -l
