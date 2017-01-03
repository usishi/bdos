#!/bin/bash
#
# Chapter 5.6 & 5.7 & 5.8 & 5.9 & 5.10
#
#
source ./definitions

echo -e "Linux API Headers hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.6"
echo -e "\e--------------------------------------------------\e[0m"
echo "Linux API Headers"
read
cd $BDROOT/sources
rm -rf $LINUX_FOLDER
tar -xf $LINUX_FILE
cd $LINUX_FOLDER
echo `pwd`
make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

echo -e "Linux API Headers TAMAMLANDI, \n Simdi Glibc hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.7"
echo -e "\e--------------------------------------------------\e[0m"
echo "Glibc"
read
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
echo -e "[Requesting program interpreter: /tools/lib64/ld-linux-x86-64.so.2]\n ciktisi goruntulenmiyorsa hata olustu.\n CTRL-C ile cikis yapin"
read
rm -v dummy.c a.out

echo -e "Glibc TAMAMLANDI, \n Simdi Libstdc hazirlacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.8"
echo -e "\e--------------------------------------------------\e[0m"
echo "Libstdc"
read
cd $BDROOT/sources
cd $GCC_FOLDER
echo `pwd`
mkdir -v build-libstdc
cd build-libstdc
../libstdc++-v3/configure --host=$BDROOT --prefix=/tools --disable-multilib --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$BDROOT/include/c++/6.2.0
make -j20 && make install

echo -e "Libstdc TAMAMLANDI, \n Simdi Binutils FAZ 2 hazirlacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.9"
echo -e "\e--------------------------------------------------\e[0m"
echo "Binutils Faz 2"
read
cd $BDROOT/sources
cd $BINUTILS_FOLDER
mkdir -v build-faz2
cd build-faz2

CC=$BDROOT-gcc
AR=$BDROOT-ar
RANLIB=$BDROOT-ranlib
../configure --prefix=/tools --disable-nls --disable-werror --with-lib-path=/tools/lib --with-sysroot
make -j20 && make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

echo -e "Binutils FAZ 2 TAMAMLANDI, \n Simdi GCC FAZ 2 hazirlacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.10"
echo -e "\e--------------------------------------------------\e[0m"
echo "GCC Faz 2"
read
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
echo -e "[Requesting program interpreter: /tools/lib64/ld-linux.so.2]\n ciktisi goruntulenmiyorsa hata olustu.\n CTRL-C ile cikis yapin"
read
rm -v dummy.c a.out

