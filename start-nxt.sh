#!/bin/bash
cd /nxt

# if a script was provided, we download it locally
# then we run it before anything else starts
if [ -n "${SCRIPT-}" ]; then
	filename=$(basename "$SCRIPT")
	wget "$SCRIPT" -O "./scripts/$filename"
	chmod u+x "./scripts/$filename"
	./scripts/$filename
fi  

cd /
# Now time to get the NRS client
wget https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$NRSVersion.zip && \
wget https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$NRSVersion.changelog.txt.asc && \
gpg --keyserver pgpkeys.mit.edu --recv-key 0xFF2A19FA && \
gpg --verify nxt-client-$NRSVersion.changelog.txt.asc && \
unzip nxt-client*.zip && \
rm *.zip *.asc && \
cd /nxt && \
rm -Rf *.exe src changelogs

# if we passed a url describing the plugins to install
# we loop thru the file
# download the plugins
# check the signatures
# install the plugins that have valid signatures
# the URL should point to a txt file with the following content
# <shasum256>	http://..../plugin.zip
if [ -n "${PLUGINS-}" ]; then
	./scripts/install-plugins.sh "$PLUGINS"
fi  

# We figure out what is the current db folder
if [ "$NXTNET" = "main" ]; then
	DB="nxt_db"
else
	DB="nxt_test_db"
fi  

# just to be sure :)
echo Database is $DB

# if we need to bootstrap, we do that first.
# Warning, bootstrapping will delete the current blockchain.
# This ENV variable must be removed for the container
# to start 'normally'.
# $BLOCKCHAINDL must point to a zip that contains the nxt_db folder itself.
if [ -n "${BLOCKCHAINDL-}" ] && [ ! -d "$DB" ]; then
	echo "$DB not found, downloading blockchain from $BLOCKCHAINDL";
	wget "$BLOCKCHAINDL" && unzip *.zip && rm *.zip
	echo "Blockchain download complete"
fi

if [ "$NXTNET" = "main" ]; then
	echo "Linking config to mainnet"
	ln -sf /nxt/conf/nxt-main.properties /nxt/conf/nxt.properties
else
	echo "Linking config to testnet"
	ln -sf /nxt/conf/nxt-test.properties /nxt/conf/nxt.properties
fi  

./run.sh