#!/bin/bash
#
# Chapter 5.6 & 5.7 & 5.8 & 5.9
#
#
source $BDROOT/setup/definitions

echo -e "Linux API Headers hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.6"
echo -e "\e--------------------------------------------------\e[0m"
echo "Linux API Headers"
read
echo -e "Bekleyin ..."

cd $BDROOT/sources
rm -rf $LINUX_FOLDER
tar -xf $LINUX_FILE
cd $LINUX_FOLDER
echo `pwd`
make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

echo -e "Linux API Headers TAMAMLANDI. \nSimdi Glibc hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.7"
echo -e "\e--------------------------------------------------\e[0m"
echo "Glibc"
read
echo -e "Bekleyin ..."

cd $BDROOT/sources
rm -rf $GLIBC_FOLDER
tar -xf $GLIBC_FILE
cd $GLIBC_FOLDER
echo `pwd`
mkdir -v build
cd build
sudo apt-get install gettext # msgfmt icin
../configure --prefix=/tools --host=$BDTARGET --build=$(../scripts/config.guess) --enable-kernel=2.6.32 --with-headers=/tools/include libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes
make -j20 && make install

echo 'int main(){}' > dummy.c
$BDTARGET-gcc dummy.c
readelf -l a.out | grep ': /tools'
echo -e "**[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]**\nciktisi goruntulenmiyorsa hata olustu.\nCTRL-C ile cikis yapin"
read
rm -v dummy.c a.out

echo -e "Glibc TAMAMLANDI. \nSimdi Libstdc hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.8"
echo -e "\e--------------------------------------------------\e[0m"
echo "Libstdc"
read
echo -e "Bekleyin ..."

cd $BDROOT/sources
cd $GCC_FOLDER
echo `pwd`
mkdir -v build-libstdc
cd build-libstdc
../libstdc++-v3/configure --host=$BDTARGET --prefix=/tools --disable-multilib --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$BDTARGET/include/c++/6.2.0
make -j20 && make install

echo -e "Simdi \e[1;34m $BDROOT/setup/003-BuildFaz2 \e[0m komutu ile devam edin."

