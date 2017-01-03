#!/bin/bash

BDROOT=/bdroot
BDTARGET=x86_64-usishi-linux-gnu

mkdir tmpbuild


if [[ ! -d $BDROOT/setup ]]; then
git clone https://github.com/usishi/bdos.git $BDROOT
fi
cd $BDROOT
setup/version-check.sh
while true; do
    read -p "Tum paketleri sorunsuz gozukuyor mu ?" eh
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
 mkdir -v $BDROOT/sources
 chmod -v a+wt $BDROOT/sources
 wget --input-file=setup/sources.list --continue --directory-prefix=$BDROOT/sources
 pushd $BDROOT/sources
 md5sum -c $BDROOT/setup/sources.md5
 popd
else
 echo -e "Paketler Indirilmis\n"
fi

libdurum=0

for lib in lib{gmp,mpfr,mpc}.la; do
  if find /usr/lib* -name $lib | grep -q $lib;then 
    echo "$lib bulundu";
  else 
    echo -e "\e[31m $lib bulunmadi\e[0m";
    set libdurum=1
  fi
done
unset lib

if [[ $libdurum -gt 0 ]]; then
  echo "Lutfen kirmizi ile belirtilmis eksik kutuphaneleri kurunuz !"
fi


echo "exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash" > ~/.bash_profile
echo -e "set +h \n umask 022 \n BDROOT=$BDROOT \n LC_ALL=POSIX \n BDTARGET=$BDTARGET \n PATH=/tools/bin:/bin:/usr/bin \n export BDROOT LC_ALL BDTARGET PATH \n alias ll='ls -lF' \n alias ls='ls --color=auto' \n" > ~/.bashrc


echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 4.2"
echo -e "\e-------------------------------------------------\e[0m"
if [[ ! -d $BDROOT/tools ]]; then
  mkdir -v $BDROOT/tools
  echo -e "Lutfen su komutu calistirin : \e[1;34m sudo ln -sv $BDROOT/tools / \e[0m"
else
  rm -rf /tools/*
  echo -e "/tools icerigi bosaltildi\n"
fi
echo -e "Lutfen su komutu calistirin : \e[1;34m source ~/.bash_profile  \e[0m"
echo "Simdi \e[1;34m $BDROOT/setup/001-BuildFaz1.sh \e[0m dosyasi ile devam edin."

