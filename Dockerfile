FROM openjdk:9

ENV SPARK_VERSION 2.0.2
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop2.7
ENV SPARK_HOME /usr/apache/${SPARK_PACKAGE}

# Install Spark
WORKDIR /usr/apache
RUN wget http://d3kbcqa49mib13.cloudfront.net/${SPARK_PACKAGE}.tgz
RUN tar -xvzf ${SPARK_PACKAGE}.tgz
RUN rm ${SPARK_PACKAGE}.tgz

WORKDIR ${SPARK_HOME}

# Setting Spark
COPY conf/* conf

EXPOSE 6066 7077 8080

CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
