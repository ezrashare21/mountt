#!/bin/bash

# mountt.sh
#
# developed by ezrashare21dev
#
# Raspberry Pi SUB flash drive mount tool
#
# $1 - drive to mount
# $2 - what to name drive when mounted
# $3 - user to assign uid and gid

if [[ $EUID -ne 0 ]]; then
  echo "you need to run this thingy as root ur else i will come to ur house"
  exit 1
fi

if [ $1 = uninstall ]
then
  rm /usr/local/bin/mountt
  exit 0
fi

if [ ! -d /mnt/mountt ]
then
  mkdir /mnt/mountt
fi

if [ $1 = -h ]
then
    echo "Help:
mountt <disk> <name> <user>
mountt -h
mountt get-disk
mountt get-uuid
mountt unmount <name>
mountt config-gen <file> <disk> <name> <user>
mountt config <file>

note: mountt config does not work. somebody please help."
    exit 0
fi

if [ $1 = get-disk ]
then
    fdisk -l
    exit 0
fi

if [ $1 = get-uuid ]
then
    ls -l /dev/disk/by-uuid/
    exit 0
fi

if [ $1 = unmount ]
then
    umount /mnt/mountt/$2
    rm -rf /mnt/mountt/$2
    exit 0
fi

if [ $1 = upgrade ]
then
  git clone https://github.com/ezrashare21/mountt
  cd mountt
  chmod +x setup
  sudo ./setup
  cd ..
  rm -rf mountt
  exit 0
fi

if [ $1 = config-gen ]
then
    touch $2
    echo /dev/$3 >> $2
    echo /mnt/mountt/$4 >> $2
    echo $5 >> $2
    exit 0
fi

if [ $1 = config ]
then
    # https://www.javatpoint.com/bash-read-file
    file=$2
    
    i=1
    mountpoint=""
    disk=""
    user=""
    while read line; do
        if [ i = 1 ]
        then
            disk=$line
        fi
        if [ i = 2 ]
        then
            mountpoint=$line
        fi
        if [ i = 3 ]
        then
            user=$line
        fi
        i=$((i+1))
    done < $file
    
    echo "mounting drive... (config)"
    
    echo $disk
    echo $mountpoint
    echo $user
    
    mkdir /mnt/mountt/$mountpoint
    mount $disk $mountpoint -o uid=$user,gid=$user
    mountpath=$mountpoint
    
    echo "..done"!
    exit 0
fi

echo "mounting drive..."

mkdir /mnt/mountt/$2
mount /dev/$1 /mnt/mountt/$2 -o uid=$3,gid=$3
mountpath=/mnt/mountt/$2

echo "drive mounted succsessfuly!"
