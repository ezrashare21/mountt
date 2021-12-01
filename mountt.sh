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

echo "attempting to upgrade..."

apt update
apt upgrade
mkdir /mnt/mountt

if [ $1 = -h ]
then
    echo "$ 1 - drive to mount"
    echo "$ 2 - what to name drive when mounted"
    echo "$ 3 - user to assign uid and gid"
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
    unmount /mnt/mountt/$2
    rm -rf /mnt/mountt/$2
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
    mountpoint = ""
    disk = ""
    user = ""
    while read line; do
        if [ i = 1 ]
        then
            disk = $line
        fi
        if [ i = 2 ]
        then
            mountpoint = $line
        fi
        if [ i = 3 ]
        then
            user = $line
        fi
        i=$((i+1))
    done < $file
    
    echo "mounting drive... (config)"
    
    mkdir mountpoint
    mount disk mountpoint -o uid=user,gid=user
    $mountpath mountpoint
    
    echo "..done"!
    exit 0
fi

echo "mounting drive..."

mkdir /mnt/mountt/$2
mount /dev/$1 /mnt/mountt/$2 -o uid=$3,gid=$3
$mountpath = /mnt/mountt/$2

echo "drive mounted succsessfuly!"
