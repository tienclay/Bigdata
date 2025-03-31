FROM debian:11

MAINTAINER Ivan Ermilov <ivan.s.ermilov@gmail.com>
MAINTAINER Giannis Mouchakis <gmouchakis@iit.demokritos.gr>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    wget \
    net-tools \
    netcat \
    libsnappy-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install OpenJDK 8 (AdoptOpenJDK or Temurin)
RUN mkdir -p /opt/java && \
    curl -L https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u402b06.tar.gz | tar -xz -C /opt/java && \
    ln -s /opt/java/jdk8u*/ /opt/java/latest

ENV JAVA_HOME=/opt/java/latest
ENV PATH=$JAVA_HOME/bin:$PATH

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS && \
    gpg --import KEYS

ENV HADOOP_VERSION=3.3.6
ENV HADOOP_URL=https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
    

RUN curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz && \
    curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc && \
    gpg --verify /tmp/hadoop.tar.gz.asc && \
    tar -xvf /tmp/hadoop.tar.gz -C /opt/ && \
    rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop && \
    mkdir -p /opt/hadoop-$HADOOP_VERSION/logs /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH=$HADOOP_HOME/bin:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
