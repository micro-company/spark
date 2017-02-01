FROM openjdk:8

ENV SPARK_VERSION=2.0.2 \
    SPARK_PACKAGE=spark-2.0.2-bin-hadoop2.7 \
    SPARK_HOME=/usr/apache/spark-2.0.2-bin-hadoop2.7 \
    SBT_VERSION=0.13.8 \
    SCALA_VERSION=2.11.7

# Install Spark
WORKDIR /usr/apache
RUN wget http://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz && \
  tar -xvzf ${SPARK_PACKAGE}.tgz && \
  rm ${SPARK_PACKAGE}.tgz

# Install Scala
RUN \
  cd /root && \
  curl -o scala-$SCALA_VERSION.tgz http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz && \
  tar -xf scala-$SCALA_VERSION.tgz && \
  rm scala-$SCALA_VERSION.tgz && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Update sbt package
RUN \
  curl -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb

# Install dependencies
RUN \
  apt-get update && \
  apt-get install -y build-essential sbt python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-2 libsasl2-modules maven libapr1-dev libsvn-dev zlib1g-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR ${SPARK_HOME}

# Setting Spark
COPY conf/* conf

EXPOSE 6066 7077 8080

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
