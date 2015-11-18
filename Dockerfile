FROM centos:centos7

MAINTAINER Apereo Foundation

ENV PATH=$PATH:$JRE_HOME/bin

RUN yum -y update \
    && yum -y install wget tar \
    && yum -y clean all

RUN set -x; \
    java_version=8u65; \
    java_bnumber=17; \
    java_semver=1.8.0_65; \
    java_hash=0e46f8669719a5d2ffa586afe3d6f3cc2560691edcd9e0a032943e82922a9c8a; 

# Download Java, verify the hash, and install \
    cd / \
    && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/$java_version-b$java_bnumber/server-jre-$java_version-linux-x64.tar.gz \
    && echo "$java_hash  server-jre-$java_version-linux-x64.tar.gz" | sha256sum -c - \
    && tar -zxvf server-jre-$java_version-linux-x64.tar.gz -C /opt \
    && rm server-jre-$java_version-linux-x64.tar.gz \
    && ln -s /opt/jdk$java_semver/ /opt/jre-home \

# Download the CAS overlay project \
    && cd / \
    && git clone https://github.com/UniconLabs/simple-cas4-overlay-template.git cas-overlay \
    && mkdir /etc/cas \
    && mkdir /etc/cas/jetty

COPY cas-overlay/etc/*.* /etc/cas
COPY thekeystore /etc/cas/jetty

EXPOSE 8080 8443

CMD ["run-jetty.sh"]