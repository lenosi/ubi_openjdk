ARG UBI_VERSION=7
ARG OPENJDK_VERSION=8


ARG IMAGE_BASE=quay.io/rhmessagingqe/ubi${UBI_VERSION}-openjdk-jdk

FROM ${IMAGE_BASE}:${OPENJDK_VERSION} AS ubi

ARG MAVEN_VERSION=3.8.4

LABEL name="UBI ${UBI_VERSION} | OpenJDK ${OPENJDK_VERSION} | Maven ${MAVEN_VERSION}" \
      release="${MAVEN_VERSION}" \
      maintaner="Dominik Lenoch <dlenoch@redhat.com>" \
      run="docker run --rm -ti <image_name:tag> /bin/bash" \
      summary="Red Hat Messaging QE Docker Image for Maven ${MAVEN_VERSION} with OpenJDK ${OPENJDK_VERSION} on ubi${IMAGE_BASE} minimal"

WORKDIR /opt
RUN microdnf --setopt=tsflags=nodocs install tar gzip -y && \
  curl https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz | tar xz && \
  microdnf remove tar -y && rpm -e --nodeps gzip && microdnf clean all

RUN ln -s apache-maven-${MAVEN_VERSION} maven

ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=$M2_HOME/bin:$PATH

RUN microdnf --setopt=tsflags=nodocs install shadow-utils -y && \
  mkdir /app && groupadd -r maven && useradd -rm -d /home/maven -s /bin/false -g maven maven && chown -R maven:maven /app && \
  microdnf remove shadow-utils -y && microdnf clean all
WORKDIR /app
USER maven
