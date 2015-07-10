#!/bin/bash

if [ "$NXTNET" = "main" ]; then
	ln -s /nxt/conf/nxt-main.properties /nxt/conf/nxt.properties
else
	ln -s /nxt/conf/nxt-test.properties /nxt/conf/nxt.properties
fi  

cd /nxt
./run.sh
