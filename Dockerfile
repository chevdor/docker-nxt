FROM phusion/baseimage:0.9.16
MAINTAINER Chevdor <chevdor@gmail.com>
LABEL version="0.1.0"

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer \
  	wget \
	unzip \
	joe \
	&& \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN mkdir /home/nxt && cd /home/nxt
RUN wget https://bitbucket.org/JeanLucPicard/nxt/downloads/nxt-client-1.5.12.zip
RUN unzip nxt-client*

VOLUME /nxt

ENV NXTNET test 			
# when running the container, you can override that using -e "NXTNET=main"

COPY ./nxt-main.properties /nxt/conf/
COPY ./nxt-test.properties /nxt/conf/
COPY ./start-nxt.sh /nxt/

CMD ["/nxt/start-nxt.sh", "/bin/bash"] 
