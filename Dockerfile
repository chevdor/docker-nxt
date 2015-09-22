FROM phusion/baseimage:0.9.16
MAINTAINER Chevdor <chevdor@gmail.com>
LABEL version="0.1.4"

ENV NRSVersion=1.5.13

RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer wget unzip joe && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir /nxt && \
  cd /

ADD scripts /nxt/scripts

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

VOLUME /nxt
WORKDIR /nxt

ENV NXTNET test 			
# when running the container, you can override that using -e "NXTNET=main"

COPY ./nxt-main.properties /nxt/conf/
COPY ./nxt-test.properties /nxt/conf/
COPY ./init-nxt.sh /nxt/

EXPOSE 6876 7876 6874 7874

CMD ["/nxt/init-nxt.sh", "/bin/bash"]