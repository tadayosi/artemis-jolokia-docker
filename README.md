# Apache Artemis Docker Image with Jolokia

A simple Dockerfile which demonstrates how to make an Apache Artemis Docker image with [Jolokia JVM agent](https://jolokia.org/reference/html/agents.html#agents-jvm) attached.

This docker image is tailored to the OpenShift platform with client certificate authentication being enabled on Jolokia JVM agent, and [hawtio-online](https://github.com/hawtio/hawtio-online) can detect the containers out of the box.

To deploy the Artemis container on OpenShift, run the following:

```sh
make deploy-openshift
```
