FROM jboss/base-jdk:11

ENV ARTEMIS_VERSION=2.15.0 \
    JOLOKIA_VERSION=1.6.2

USER root

WORKDIR /opt

# Download Artemis
RUN curl -o artemis.tar.gz https://repository.apache.org/content/repositories/releases/org/apache/activemq/apache-artemis/${ARTEMIS_VERSION}/apache-artemis-${ARTEMIS_VERSION}-bin.tar.gz && \
    tar xf artemis.tar.gz && \
    mv apache-artemis-${ARTEMIS_VERSION} artemis && \
    rm artemis.tar.gz && \
    chown jboss:jboss -R artemis

# Switch to jolokia-ssl.properties when trying client certificate auth
ADD jolokia-ssl.properties /opt/artemis/jolokia.properties

# Download Jolokia
RUN cd artemis && \
    curl -o jolokia.jar https://repo1.maven.org/maven2/org/jolokia/jolokia-jvm/${JOLOKIA_VERSION}/jolokia-jvm-${JOLOKIA_VERSION}-agent.jar && \
    chown jboss:jboss jolokia.jar jolokia.properties

# Add jboss user to the root group for running on OpenShift
RUN usermod -g root -G jboss jboss

USER jboss

WORKDIR /opt/artemis

# Create broker instance
RUN ./bin/artemis create test \
      --user admin \
      --password admin \
      --role amq \
      --queues test \
      --require-login && \
    chmod g+rw -R test

RUN sed -i 's/localhost:8161/0.0.0.0:8161/g' test/etc/bootstrap.xml && \
    sed -i 's/localhost[*]/*/g' test/etc/jolokia-access.xml && \
    echo -e "\nJAVA_ARGS=\"-javaagent:\${ARTEMIS_HOME}/jolokia.jar=config=\${ARTEMIS_HOME}/jolokia.properties \$JAVA_ARGS\"" >> test/etc/artemis.profile

EXPOSE 8161 61616 8778

ENTRYPOINT ["/opt/artemis/test/bin/artemis", "run"]
