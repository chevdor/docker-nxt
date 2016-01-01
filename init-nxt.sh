#!/bin/sh

if [ ! -f "/nxt/.init" ]; then 
	echo -e " init-nxt.sh: Performing init..."

	# If there is no .init, this can be a new install
	# or an upgrade... in the second case, we want to do some cleanup to ensure
	# that the upgrade will go smooth
	
	rm -Rf /nxt/lib && \
	mkdir /nxt/conf
	
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
	wget --no-check-certificate https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$NRSVersion.zip && \
	wget --no-check-certificate  https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-$NRSVersion.changelog.txt.asc && \
	gpg --keyserver pgpkeys.mit.edu --recv-key 0x811d6940e1e4240c && \
	gpg --verify nxt-client-$NRSVersion.changelog.txt.asc && \
	unzip -o nxt-client*.zip && \
	rm *.zip *.asc && \
	cd /nxt && \
	rm -Rf *.exe src changelogs

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
	# $BLOCKCHAINDL must point to a zip that contains the nxt_db folder itself.
	if [ -n "${BLOCKCHAINDL-}" ] && [ ! -d "$DB" ]; then
		echo " init-nxt.sh: $DB not found, downloading blockchain from $BLOCKCHAINDL";
		wget "$BLOCKCHAINDL" && unzip *.zip && rm *.zip
		echo " init-nxt.sh: Blockchain download complete"
	fi

	# linking of the config
	if [ "$NXTNET" = "main" ]; then
		echo " init-nxt.sh: Linking config to mainnet"
		cp /nxt-boot/conf/nxt-main.properties /nxt/conf/nxt.properties
	else
		echo " init-nxt.sh: Linking config to testnet"
		cp /nxt-boot/conf/nxt-test.properties /nxt/conf/nxt.properties
	fi  

	# If we did all of that, we dump a file that will signal next time that we
	# should not run the init-script again
	touch /nxt/.init
else
	echo -e " init-nxt.sh: Init already done, skipping init."
fi;

cd /nxt
./run.sh