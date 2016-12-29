#!/bin/bash


echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.3"
echo -e "\e-------------------------------------------------\e[0m"
if [[ "`ls -l /bin/sh`" == *dash* ]]; then
 echo -e "dash yerine bash kullanilmali"
 echo -e "\e[31m Lütfen Pencerede 'NO' seciniz !!!\n Simdi devam etmek icin bir tusa basiniz \e[0m"
 read
 sudo dpkg-reconfigure dash
else
 echo -e "sh /bin/bash'e yonlenmis sorun yok\n"
fi

echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.4"
echo -e "\e-------------------------------------------------\e[0m"
echo "binutils Faz 1"
cd $BDROOT/sources
BINUTILS=`ls binutils*tar* | sed -s 's/.tar.bz2//g'`
rm -rf $BINUTILS
sleep 3
tar -xf $BINUTILS.tar.bz2
cd $BINUTILS && mkdir -v build && cd build
../configure --prefix=/tools --with-sysroot=$BDROOT --with-lib-path=/tools/lib --target=$BDTARGET --disable-nls --disable-werror
make -j20 
case $(uname -m) in
  x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
esac
make install

echo -e "binutils Faz 1 TAMAMLANDI, \n Simdi GCC Faz 1 hazirlanacak \nbir tusa basarak devam edin ..."
read
cd $BDROOT/sources
GCCFOLDER=`ls gcc-*tar* | sed -s 's/.tar.bz2//g'`
rm -rf $GCCFOLDER
tar -xf $GCCFOLDER.tar.bz2
cd $GCCFOLDER
echo "`pwd`"
WORKFILE=`ls ../mpfr-*tar* | sed -s 's/.tar.xz//g'| sed -s 's/..\///g'`
echo $WORKFILE
tar -xf ../$WORKFILE.tar.xz
mv $WORKFILE mpfr


WORKFILE=`ls ../gmp-*tar* | sed -s 's/.tar.xz//g'| sed -s 's/..\///g'`
echo $WORKFILE
tar -xf ../$WORKFILE.tar.xz
mv $WORKFILE gmp


WORKFILE=`ls ../mpc-*tar* | sed -s 's/.tar.xz//g'| sed -s 's/..\///g'`
echo $WORKFILE
tar -xf ../$WORKFILE.tar.xz
mv $WORKFILE mpc


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

mkdir build
cd build

../configure --target=$BDTARGET --prefix=/tools --with-glibc-version=2.11 --with-sysroot=$BDROOT --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libmpx --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++

make -j20 && make install
