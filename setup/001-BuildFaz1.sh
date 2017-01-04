#!/bin/bash
#
# Chapter 5.3 & 5.4 & 5.5
#
#
source $BDROOT/setup/definitions

echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.3"
echo -e "\e--------------------------------------------------\e[0m"
echo "/bin/sh kontrolu"
if [[ "`ls -l /bin/sh`" == *dash* ]]; then
 echo -e "dash yerine bash kullanilmali"
 echo -e "\e[31m Lütfen Pencerede 'NO' seciniz !!!\n Simdi devam etmek icin bir tusa basiniz \e[0m"
 read
 sudo dpkg-reconfigure dash
else
 echo -e "sh /bin/bash'e yonlenmis sorun yok\n"
fi

echo -e "Binutils Faz 1 hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.4"
echo -e "\e--------------------------------------------------\e[0m"
echo "Binutils Faz 1"
echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $BINUTILS_FOLDER
tar -xf $BINUTILS_FILE
cd $BINUTILS_FOLDER
mkdir -v build
cd build
../configure --prefix=/tools --with-sysroot=$BDROOT --with-lib-path=/tools/lib --target=$BDTARGET --disable-nls --disable-werror
make -j20 
case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install
cd $BDROOT/sources
rm -rf $BINUTILS_FOLDER

echo -e "Binutils Faz 1 TAMAMLANDI \nSimdi GCC Faz 1 hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.5"
echo -e "\e--------------------------------------------------\e[0m"
echo "GCC Faz 1"
read
echo -e "\e[32mENVIRONMENT KONTROL\e[0m"
echo -e "\e[1;34mBDROOT=$BDROOT\e[0m"
echo -e "\e[1;34mBDTARGET=$BDTARGET\e[0m"
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GCC_FOLDER
tar -xf $GCC_FILE
cd $GCC_FOLDER
echo "`pwd`"
tar -xf ../$MPFR_FILE
mv -v $MPFR_FOLDER mpfr
tar -xf ../$GMP_FILE
mv -v $GMP_FOLDER gmp
tar -xf ../$MPC_FILE
mv -v $MPC_FOLDER mpc
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
mkdir -v build
cd build
../configure --target=$BDTARGET --prefix=/tools --with-glibc-version=2.11 --with-sysroot=$BDROOT --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libmpx --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++
make -j20 && make install
cd $BDROOT/sources
rm -rf $GCC_FOLDER

echo -e "Simdi \e[1;34m $BDROOT/setup/002-PrepareHeaders.sh \e[0m komutu ile devam edin."

