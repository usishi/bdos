#!/bin/bash

sudo echo "`whoami` ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers

if [[ ! -d /bdroot ]]; then  
  sudo mkdir -pv /bdroot
  sudo chown bdosadmin:bdosadmin /bdroot
fi

BDROOT=/bdroot
BDTARGET=$(uname -m)-usishi-linux-gnu

if [[ ! -d $BDROOT/setup ]]; then
git clone https://github.com/usishi/bdos.git $BDROOT
fi
cd $BDROOT
echo -e "\e[32mPaket Kontrolu yapiliyor.\e[0m"
setup/version-check.sh
while true; do
    read -p "Tum paketleri sorunsuz gozukuyor mu ?(e/h)" eh
    case $eh in
        [Ee]* ) break;;
        [Hh]* ) exit;;
        * ) echo "Lutfen Evet(e) ya da Hayir(h) cevabi verin";;
    esac
done

echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 3.1"
echo -e "\e-------------------------------------------------\e[0m"
if [[ ! -d $BDROOT/sources ]]; then
 sudo mkdir -v $BDROOT/sources 
 chmod -v a+wt $BDROOT/sources
 wget --input-file=setup/sources.list --continue --directory-prefix=$BDROOT/sources
 pushd $BDROOT/sources
 md5sum -c $BDROOT/setup/sources.md5
 popd
else
 echo -e "Paketler Indirilmis\n"
fi

for lib in lib{gmp,mpfr,mpc}.la; do
  if find /usr/lib* -name $lib | grep -q $lib;then 
    echo "$lib bulundu";
  else 
    echo -e "\e[31m $lib bulunmadi\e[0m";
    set libdurum=1
  fi
done
unset lib

echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 4.2"
echo -e "\e-------------------------------------------------\e[0m"
if [[ ! -d $BDROOT/tools ]]; then
  sudo mkdir -v $BDROOT/tools
  sudo ln -sv $BDROOT/tools /
else
  sudo rm -rf /tools/*
  echo -e "/tools icerigi bosaltildi\n"
fi
echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" > ~/.bash_profile
echo "set +h
umask 022
BDROOT=$BDROOT
LC_ALL=POSIX
BDTARGET=$BDTARGET
PATH=/tools/bin:/bin:/usr/bin
export BDROOT LC_ALL BDTARGET PATH
alias ll='ls -lF'
alias ls='ls --color=auto'" > ~/.bashrc

echo -e "Lutfen su komutu calistirin : \e[1;34m source ~/.bash_profile  \e[0m"
echo -e "Simdi \e[1;34m $BDROOT/setup/001-BuildFaz1.sh \e[0m komutu ile devam edin."

