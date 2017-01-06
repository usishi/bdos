#!/bin/bash
#
# bu script direkt calistirmak icin degildir.
# .bashrc icinden kaynak olarak belirtilen fonksiyonlar icerir

function bd_finpkg(){
 cd $LFS/sources
 
 FILE=`cat bd_file`
 FOLDER=`cat bd_folder`

 rm -rvf $FOLDER
 rm -rv bd_file
 rm -rv bd_folder
 echo `pwd` 
}


function bd_preppkg(){
 cd $LFS/sources
 rm -v bd_file
 rm -v bd_folder
 echo $1 > bd_file
 FOLDER=`cat bd_file | sed -s 's/.tar.*//g'`
 echo "$FOLDER" > bd_folder
 tar -xvf $1
 cd $FOLDER
 mkdir -v build
 cd build
 echo `pwd` 
 echo "------------- simdi config yapabilirsiniz ------"
}

function test(){
  echo $1
}
