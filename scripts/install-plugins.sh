#!/bin/bash

url=$1
workdir=plugindl
tmp=plugins.txt
echo "Getting plugins from $url"
wget $url -O "$workdir/$tmp"
mkdir "$workdir"

cat $tmp | while read line
do
   #echo $line
   IFS=' ' read -a myarray <<< "$line"
   pluginURL=${myarray[1]}
   pluginChecksum=${myarray[0]}
   filename=$(basename "$pluginURL")
   echo -e "  checksum:    $pluginChecksum"
   echo -e "  url:      $pluginURL"
   echo -e "  file:     $filename"
   echo -e   

   wget "$pluginURL" -O "$workdir/$filename"
   if [ `shasum -a 256 "$workdir/$filename"` = $pluginChecksum ]; then
      echo -e "OK"
   else
   echo -e "NO OK"
  
   fi;
done
echo $line

# rm -Rf "$workdir"