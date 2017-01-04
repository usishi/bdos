#!/bin/bash
#
# Chapter 6.2 & 6.4
#
#
BDROOT="/bdroot"

if [[ "`whoami`" != "root" ]]; then
  echo "Root moduna geciliyor"
  echo "Ardından tekrar $BDROOT/setup/005-BuildSystemFaz1.sh komutunu calistirin"
  sudo su -
  exit
fi
echo `pwd`
[[ -z $BDROOT ]] && echo -e "BDROOT ayarlanmamis.\nBu komut ile ayarlayin: \e[1;34m echo 'BDROOT=/bdroot; export BDROOT' >> /root/.bashrc \e[0m" && exit


echo -e "Kernel Virtual Folders hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.2"
echo -e "\e--------------------------------------------------\e[0m"
echo "Kernel Virtual Folders"
read
echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
echo -e "Bekleyin ..."
mkdir -pv $BDROOT/{dev,proc,sys,run}
mknod -m 600 $BDROOT/dev/console c 5 1
mknod -m 666 $BDROOT/dev/null c 1 3
mount -v --bind /dev $BDROOT/dev
mount -vt devpts devpts $BDROOT/dev/pts -o gid=5,mode=620
mount -vt proc proc $BDROOT/proc
mount -vt sysfs sysfs $BDROOT/sys
mount -vt tmpfs tmpfs $BDROOT/run
if [ -h $BDROOT/dev/shm ]; then
  mkdir -pv $BDROOT/$(readlink $BDROOT/dev/shm)
fi

echo -e "Chroot yapilacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.4"
echo -e "\e--------------------------------------------------\e[0m"
echo "Chroot $BDROOT"
read
echo -e "/setup/006-BuildSystemFaz2.sh komutu ile devam edin ..."
chroot "$BDROOT" /tools/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /tools/bin/bash --login +h