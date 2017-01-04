#
# Chapter 6.5 & ...
#
#
if [[ -f /setup/definitions ]]; then
  source /setup/definitions
else
  echo "definitions dosyasi bulunamadi"
  echo "ENVIRONMENT degerlerini kontrol edin"
  exit
fi

if [[ ! -f /root/OK ]]; then 
  echo -e "BDOS Filesystem hazirlanacak \nbir tusa basarak devam edin ..."
  echo -e "\e[32m-------------------------------------------------"
  echo -e "\t Chapter 6.5"
  echo -e "\e--------------------------------------------------\e[0m"
  echo "BDOS Filesystem"
  read
  echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
  echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
  echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
  echo -e "Bekleyin ..."
  mkdir -pv /{bin,boot,etc/{opt,sysconfig},lib/firmware,mnt}
  mkdir -pv /{sbin,var}
  install -dv -m 0750 /root
  install -dv -m 1777 /tmp /var/tmp
  mkdir -pv /usr/{bin,include,lib,sbin,src}
  mkdir -pv usr/share/{color,dict,doc,info,locale,man}
  mkdir -v  /usr/share/{misc,terminfo,zoneinfo}
  mkdir -v  /usr/libexec
  mkdir -pv /usr/share/man/man{1..8}
  mkdir -pv /bds/{,lib,etc,bin}
  case $(uname -m) in
   x86_64) ln -sv lib /lib64
           ln -sv lib /usr/lib64
           ln -sv lib /usr/local/lib64 ;;
  esac
  mkdir -v /var/{db,log,mail,spool}
  ln -sv /run /var/run
  ln -sv /run/lock /var/lock
  mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}

  echo -e "\e[32m-------------------------------------------------"
  echo -e "\t Chapter 6.6"
  echo -e "\e--------------------------------------------------\e[0m"
  ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
  ln -sv /tools/bin/perl /usr/bin
  ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
  ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
  sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
  ln -sv bash /bin/sh
  ln -sv /proc/self/mounts /etc/mtab
  echo -e "root:x:0:0:root:/root:/bin/bash
  bin:x:1:1:bin:/dev/null:/bin/false
  daemon:x:6:6:Daemon User:/dev/null:/bin/false
  messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
  nobody:x:99:99:Unprivileged User:/dev/null:/bin/false" > /etc/passwd
  echo -e "root:x:0:
  bin:x:1:daemon
  sys:x:2:
  kmem:x:3:
  tape:x:4:
  tty:x:5:
  daemon:x:6:
  floppy:x:7:
  disk:x:8:
  lp:x:9:
  dialout:x:10:
  audio:x:11:
  video:x:12:
  utmp:x:13:
  usb:x:14:
  cdrom:x:15:
  adm:x:16:
  messagebus:x:18:
  systemd-journal:x:23:
  input:x:24:
  mail:x:34:
  nogroup:x:99:
  users:x:999:" > /etc/group
  echo -e "\e[32m Yeniden BASH calistirilması gerek. Bu oturum sonlanacak \e[0m.
  Tekrar \e[1;34m /setup/006-BuildSystemFaz2.sh \e[0m calistirilmalidir!
  bir tusa basarak devam edin ..."
  read
  echo > /root/OK
  exec /tools/bin/bash --login +h
fi
rm /root/OK
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp

echo -e "BDOS Filesystem TAMAMLANDI \nSimdi Linux API Headers hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.7"
echo -e "\e--------------------------------------------------\e[0m"
echo "Linux API Headers"
read
echo -e "Bekleyin ..."
cd /sources
rm -rf $LINUX_FOLDER
tar -xf $LINUX_FILE
cd $LINUX_FOLDER
make mrproper
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include
cd /sources
rm -rf $LINUX_FOLDER

echo -e "Linux API Headers TAMAMLANDI \nSimdi Man-Pages hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.8"
echo -e "\e--------------------------------------------------\e[0m"
echo "Man-Pages"
read
echo -e "Bekleyin ..."
cd /sources
rm -rf $MANPAGES_FOLDER
tar -xf $MANPAGES_FILE
cd $MANPAGES_FOLDER
echo `pwd`
make -j20 install

echo -e "Man-Pages TAMAMLANDI \nSimdi Glibc hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.9"
echo -e "\e--------------------------------------------------\e[0m"
echo "Glibc"
read
echo -e "Bekleyin ..."
cd /sources
rm -rf $GLIBC_FOLDER
tar -xf $GLIBC_FILE
cd $GLIBC_FOLDER
patch -Np1 -i ../$GLIBC_PATCH
mkdir -v build
cd build
../configure --prefix=/usr --enable-kernel=2.6.32 --enable-obsolete-rpc
make -j20 && make check
echo "Test sonuclarini kontrol edin!"
echo "Asagidaki testlerin FAIL olmasi olagandir:
posix/tst-getaddrinfo4
posix/tst-getaddrinfo5
rt/tst-cputimer1 
rt/tst-cpuclock2
nptl/tst-thread-affinity-{pthread,pthread2,sched}
malloc/tst-malloc-usable
nptl/tst-cleanupx4.
"
read
touch /etc/ld.so.conf
make install
cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd
mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
echo -e "
passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files" > /etc/nsswitch.conf
tar -xf ../../$TZDATA_FILE
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO
cp -v /usr/share/zoneinfo/Europe/Istanbul /etc/localtime
echo -e "/bds/lib" > /etc/ld.so.conf
cd /sources
rm -rf $GLIBC_FOLDER

echo -e "Glibc TAMAMLANDI \nSimdi Toolchain hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 6.10"
echo -e "\e--------------------------------------------------\e[0m"
echo "Toolchain"
read
echo -e "Bekleyin ..."
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-usishi-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-usishi-linux-gnu/bin/ld
echo -e "Birazdan yapilacak degisikliklerin 
uygulandigina emin olmak icin ilgili dosyalara goz atın"
read
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
echo -e "**[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]**\nciktisi goruntulenmiyorsa hata olustu.\nCTRL-C ile cikis yapin"
read
rm -v dummy.c a.out
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
echo -e "Tum satirlar succeeded sekinde olmalidir"
read
grep -B1 '^ /usr/include' dummy.log
echo -e "Asagidaki gibi cikti olmalidir:
#include <...> search starts here:
 /usr/include"
 read
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
echo -e "Son satirlarda asagidaki gibi goruntulenmelidir:
SEARCH_DIR("/usr/lib")
SEARCH_DIR("/lib");"
read
grep "/lib.*/libc.so.6 " dummy.log
echo -e "Asagidakine benzer goruntulenmelidir:
attempt to open /lib/libc.so.6 succeeded" 
read
grep found dummy.log
echo -e "Asagidakine benzer goruntulenmelidir
found ld-linux.so.2 at /lib/ld-linux.so.2
Diger turlu CTRL-C ile IPTAL EDIN!"
read
rm -v dummy.c a.out dummy.log

