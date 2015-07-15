#!/bin/bash

url=$1
workdir=plugindl
tmp=plugins.txt
echo "Getting plugins from $url"
mkdir "$workdir"
wget -q $url -O "$workdir/$tmp"

pluginsFolder=/nxt/html/ui/plugins/
# if we passed a url describing the plugins to install
# we loop thru the file, 
# download the plugins
# check the signatures
# install the plugins that have valid signatures
# the URL should point to a txt file with the following content
# <shasum256>  http://..../plugin.zip
    
cat "$workdir/$tmp" | while read line
do
   #echo $line
   IFS=$'\t' read -a myarray <<< "$line"
   pluginURL=${myarray[1]}
   pluginChecksum=${myarray[0]}
   filename=$(basename "$pluginURL")
   
   echo -e "  url       : $pluginURL"
   echo -e "  file      : $filename"
   echo -e "  expected  : $pluginChecksum"
   
   wget -q "$pluginURL" -O "$workdir/$filename"
   IFS=' ' read -a array2 <<< `shasum -a 256 "$workdir/$filename"` 
   checksum=${array2[0]}
   echo -e "  checksum  : $checksum"
   
   if [ "$checksum" == "$pluginChecksum" ]; then
      echo -e "Checksum for $filename matched - Installing plugin"
      ./scripts/install-nxt-plugin.sh "$pluginsFolder" "$workdir/$filename"
   else
      echo -e "Checksum for $filename FAILED - Skipping install"
   fi;

   echo -e   
done

rm -Rf "$workdir"