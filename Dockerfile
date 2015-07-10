FROM phusion/baseimage:0.9.16
MAINTAINER Chevdor <chevdor@gmail.com>
LABEL version="0.0.1"

RUN apt-get update && apt-get -y install \
	wget \
	unzip \
	joe

# this is to be changed...
RUN wget https://dl.dropboxusercontent.com/u/8099076/NXT/jre.zip
RUN unzip jre.zip
RUN chmod +x jre/bin/*
RUN ln -s /jre/bin/java /bin/java

RUN mkdir /home/nxt && cd /home/nxt
RUN wget https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-1.5.12.zip
RUN unzip nxt-client*

VOLUME /nxt

ENV NXTNET test 			
# when running the container, you can override that using -e "NXTNET=main"

COPY ./nxt-main.properties /nxt/conf/
COPY ./nxt-test.properties /nxt/conf/
COPY ./start-nxt.sh /nxt/

CMD cd /nxt && ./start-nxt.sh
