#!/bin/bash
#
# Chapter 5.11 ve diger 5.x bolumleri
#
#
source ./definitions

echo -e "Tcl-core hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.11"
echo -e "\e--------------------------------------------------\e[0m"
echo "Tcl-core"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $TCLCORE_FOLDER
tar -xf $TCLCORE_FILE
cd $TCLCORE_FOLDER
echo `pwd`
cd unix
./configure --prefix=/tools
make -j20
TZ=UTC make test
echo -e "Test sonuclarini kontrol edin. Hata olması KRITIK degil!"
read
make install
chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh

echo -e "Tcl-core TAMAMLANDI. \nSimdi Expect hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.12"
echo -e "\e--------------------------------------------------\e[0m"
echo "Expect"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $EXPECT_FOLDER
tar -xf $EXPECT_FILE
cd $EXPECT_FOLDER
echo `pwd`
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure --prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include
make -j20 && make test && make SCRIPTS="" install

echo -e "Expect TAMAMLANDI. \nSimdi DejaGNU hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.13"
echo -e "\e--------------------------------------------------\e[0m"
echo "DejaGNU"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $DEJAGNU_FOLDER
tar -xf $DEJAGNU_FILE
cd $DEJAGNU_FOLDER
echo `pwd`
./configure --prefix=/tools
make install && make check

echo -e "DejaGNU TAMAMLANDI. \nSimdi Check hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.14"
echo -e "\e--------------------------------------------------\e[0m"
echo "Check"
read
echo -e "Bekleyin ..."
PKG_CONFIG= ./configure --prefix=/tools
make && make check && make install

echo -e "Check TAMAMLANDI. \nSimdi Ncurses hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.15"
echo -e "\e--------------------------------------------------\e[0m"
echo "Ncurses"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $NCURSES_FOLDER
tar -xf $NCURSES_FILE
cd $NCURSES_FOLDER
echo `pwd`
sed -i s/mawk// configure
./configure --prefix=/tools --with-shared --without-debug --without-ada --enable-widec --enable-overwrite
make -j20 && make install

echo -e "Ncurses TAMAMLANDI. \nSimdi Bash hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.16"
echo -e "\e--------------------------------------------------\e[0m"
echo "Bash"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $BASH_FOLDER
tar -xf $BASH_FILE
cd $BASH_FOLDER
echo `pwd`
./configure --prefix=/tools --without-bash-malloc
make -j20 && make tests && make install
ln -sv bash /tools/bin/sh

echo -e "Bash TAMAMLANDI. \nSimdi Bzip hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.17"
echo -e "\e--------------------------------------------------\e[0m"
echo "Bzip"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $BZIP_FOLDER
tar -xf $BZIP_FILE
cd $BZIP_FOLDER
echo `pwd`
make && make PREFIX=/tools install

echo -e "Bzip TAMAMLANDI. \nSimdi Coreutils hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.18"
echo -e "\e--------------------------------------------------\e[0m"
echo "Coreutils"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $COREUTILS_FOLDER
tar -xf $COREUTILS_FILE
cd $COREUTILS_FOLDER
echo `pwd`
./configure --prefix=/tools --enable-install-program=hostname
make -j20 && make RUN_EXPENSIVE_TESTS=yes check && make install

echo -e "Coreutils TAMAMLANDI. \nSimdi Diffutils hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.19"
echo -e "\e--------------------------------------------------\e[0m"
echo "Diffutils"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $DIFFUTILS_FOLDER
tar -xf $DIFFUTILS_FILE
cd $DIFFUTILS_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Diffutils TAMAMLANDI. \nSimdi File hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.20"
echo -e "\e--------------------------------------------------\e[0m"
echo "File"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $FILE_FOLDER
tar -xf $FILE_FILE
cd $FILE_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "File TAMAMLANDI. \nSimdi FindUtils hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.21"
echo -e "\e--------------------------------------------------\e[0m"
echo "FindUtils"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $FINDUTILS_FOLDER
tar -xf $FINDUTILS_FILE
cd $FINDUTILS_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "FindUtils TAMAMLANDI. \nSimdi Gawk hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.22"
echo -e "\e--------------------------------------------------\e[0m"
echo "Gawk"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GAWK_FOLDER
tar -xf $GAWK_FILE
cd $GAWK_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Gawk TAMAMLANDI. \nSimdi Gettext hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.23"
echo -e "\e--------------------------------------------------\e[0m"
echo "Gettext"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GETTEXT_FOLDER
tar -xf $GETTEXT_FILE
cd $GETTEXT_FOLDER
echo `pwd`
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

echo -e "Gexttext TAMAMLANDI. \nSimdi Grep hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.24"
echo -e "\e--------------------------------------------------\e[0m"
echo "Grep"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GREP_FOLDER
tar -xf $GREP_FILE
cd $GREP_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Grep TAMAMLANDI. \nSimdi Gzip hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.25"
echo -e "\e--------------------------------------------------\e[0m"
echo "Gzip"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $GZIP_FOLDER
tar -xf $GZIP_FILE
cd $GZIP_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Gzip TAMAMLANDI. \nSimdi M4 hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.26"
echo -e "\e--------------------------------------------------\e[0m"
echo "M4"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $M4_FOLDER
tar -xf $M4_FILE
cd $M4_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "M4 TAMAMLANDI. \nSimdi Make hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.27"
echo -e "\e--------------------------------------------------\e[0m"
echo "Make"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $MAKE_FOLDER
tar -xf $MAKE_FILE
cd $MAKE_FOLDER
echo `pwd`
./configure --prefix=/tools --without-guile
make -j20 && make check && make install

echo -e "Make TAMAMLANDI. \nSimdi Patch hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.28"
echo -e "\e--------------------------------------------------\e[0m"
echo "Patch"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $PATCH_FOLDER
tar -xf $PATCH_FILE
cd $PATCH_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Patch TAMAMLANDI. \nSimdi Perl hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.29"
echo -e "\e--------------------------------------------------\e[0m"
echo "Perl"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $PERL_FOLDER
tar -xf $PERL_FILE
cd $PERL_FOLDER
echo `pwd`
sh Configure -des -Dprefix=/tools -Dlibs=-lm
make -j 20
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.24.0
cp -Rv lib/* /tools/lib/perl5/5.24.0

echo -e "Perl TAMAMLANDI. \nSimdi Sed hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.30"
echo -e "\e--------------------------------------------------\e[0m"
echo "Sed"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $SED_FOLDER
tar -xf $SED_FILE
cd $SED_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Sed TAMAMLANDI. \nSimdi Tar hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.31"
echo -e "\e--------------------------------------------------\e[0m"
echo "Tar"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $TAR_FOLDER
tar -xf $TAR_FILE
cd $TAR_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Tar TAMAMLANDI. \nSimdi Textinfo hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.32"
echo -e "\e--------------------------------------------------\e[0m"
echo "Textinfo"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $TEXTINFO_FOLDER
tar -xf $TEXTINFO_FILE
cd $TEXTINFO_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "Textinfo TAMAMLANDI. \nSimdi Util-linux hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.33"
echo -e "\e--------------------------------------------------\e[0m"
echo "Util-linux"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $UTILLINUX_FOLDER
tar -xf $UTILLINUX_FILE
cd $UTILLINUX_FOLDER
echo `pwd`
./configure --prefix=/tools --without-python --disable-makeinstall-chown --without-systemdsystemunitdir PKG_CONFIG=""
make -j20 && make install

echo -e "Util-linux TAMAMLANDI. \nSimdi Xz hazirlanacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.34"
echo -e "\e--------------------------------------------------\e[0m"
echo "Xz"
read
echo -e "Bekleyin ..."
cd $BDROOT/sources
rm -rf $XZ_FOLDER
tar -xf $XZ_FILE
cd $XZ_FOLDER
echo `pwd`
./configure --prefix=/tools
make -j20 && make check && make install

echo -e "XZ TAMAMLANDI. \nSimdi Stripping yapilacak \nbir tusa basarak devam edin ..."
echo -e "\e[32m-------------------------------------------------"
echo -e "\t Chapter 5.35"
echo -e "\e--------------------------------------------------\e[0m"
echo "File format not recognized kayitlari olagandir."
echo "Stripping"
read
echo -e "Bekleyin ..."
strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man,doc}

