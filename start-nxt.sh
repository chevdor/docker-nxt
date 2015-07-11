#!/bin/bash
cd /nxt

if [ "$NXTNET" = "main" ]; then
	DB="nxt_db"
else
	DB="nxt_test_db"
fi  

echo Database is $DB

# if we need to bootstrap, we do that first.
# Warning, bootstrapping will delete the current blockchain.
# This ENV variable must be removed for the container
# to start 'normally'.
# $BLOCKCHAINDL must point to a zip that contains the nxt_db folder itself.
if [ -n "${BLOCKCHAINDL-}" ] && [ ! -d "$DB" ]; then
	wget "$BLOCKCHAINDL" && unzip *.zip && rm *.zip
fi

if [ "$NXTNET" = "main" ]; then
	ln -s /nxt/conf/nxt-main.properties /nxt/conf/nxt.properties
else
	ln -s /nxt/conf/nxt-test.properties /nxt/conf/nxt.properties
fi  

./run.sh


