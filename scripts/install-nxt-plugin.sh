# usage
# ./install-nxt-plugin.sh <target> plugin1.zip plugin2.zip ...

target=$1
echo "Installing NXT plugins into $target"
array=( "$@" )
arraylength=${#array[@]}

for (( i=2; i<${arraylength}+1; i++ ));
do
   p="${array[$i-1]}";
   unzip -o "$p"  -x "__MACOSX*" -d "$target"
done