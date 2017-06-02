FROM ubuntu:14.04

MAINTAINER Eranga Bandara (erangaeb@gmail.com)

# install java and other required packages
RUN apt-get update -y
RUN apt-get install -y python-software-properties
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y

# install java
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /var/cache/oracle-jdk7-installer

# set JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# filebeat package
ENV BEAT_PKG filebeat-5.2.1-linux-x86_64

# download and install filebeat
RUN cd /
RUN wget https://artifacts.elastic.co/downloads/beats/filebeat/${BEAT_PKG}.tar.gz 
RUN tar xvzf ${BEAT_PKG}.tar.gz
RUN rm -f ${BEAT_PKG}.tar.gz
RUN mv /${BEAT_PKG} /filebeat

RUN ls -al /filebeat

# filebeat config dir 
RUN mkdir /config

# add filebeat.yml to config 
ADD filebeat.yml /config/filebeat.yml

# as a volume at the end
VOLUME ["/config"]

# start logstash
CMD ["/filebeat/filebeat", "-e", "-c", "/config/filebeat.yml"]
