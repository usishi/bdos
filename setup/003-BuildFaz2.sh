#!/bin/bash
#
# Chapter 5.9 & 5.10
#
#
if [[ -f $BDROOT/setup/definitions ]]; then
	source $BDROOT/setup/definitions
else
	echo "definitions dosyasi bulunamadi"
	echo "ENVIRONMENT degerlerini kontrol edin"
	exit
fi

echo -e "Binutils FAZ 2 hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.9"
echo -e "\e--------------------------------------------------\e[0m"
echo "Binutils Faz 2"
echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $BINUTILS_FOLDER
tar -xf $BINUTILS_FILE
cd $BINUTILS_FOLDER
mkdir -v build
cd build
CC=$BDTARGET-gcc
AR=$BDTARGET-ar
RANLIB=$BDTARGET-ranlib
../configure --prefix=/tools --disable-nls --disable-werror --with-lib-path=/tools/lib --with-sysroot
make -j20 && make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
cd $BDROOT/sources
rm -rf $BINUTILS_FOLDER

echo -e "Binutils FAZ 2 TAMAMLANDI \nSimdi GCC FAZ 2 hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.10"
echo -e "\e--------------------------------------------------\e[0m"
echo "GCC Faz 2"
echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GCC_FOLDER
tar -xf $GCC_FILE
cd $GCC_FOLDER
echo `pwd`
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($BDTARGET-gcc -print-libgcc-file-name)`/include-fixed/limits.h
for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done
tar -xf ../$MPFR_FILE
mv -v $MPFR_FOLDER mpfr
tar -xf ../$GMP_FILE
mv -v $GMP_FOLDER gmp
tar -xf ../$MPC_FILE
mv -v $MPC_FOLDER mpc
mkdir -v build
cd build
CC=$BDTARGET-gcc
CXX=$BDTARGET-g++
AR=$BDTARGET-ar
RANLIB=$BDTARGET-ranlib
../configure --prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-languages=c,c++ --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp
make -j20 && make install
ln -sv gcc /tools/bin/cc
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
echo -e "\e[1;34m[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]\e[0m\nciktisi goruntulenmiyorsa hata olustu.\nCTRL-C ile cikis yapin"
read
rm -v dummy.c a.out
cd $BDROOT/sources
rm -rf $GCC_FOLDER

echo -e "Simdi \e[1;34m $BDROOT/setup/004-OtherTools.sh \e[0m komutu ile devam edin."
