ARG UBI_VERSION=7
ARG UBI_VERSION_MINOR=9
ARG OPENJDK_VERSION=8
ARG MAVEN_VERSION=3.6.3

ARG IMAGE_BASE=quai.io/rhmessagingqe/ubi${UBI_VERSION}-openjdk-jdk

FROM ${IMAGE_BASE}:${OPENJDK_VERSION} AS UBI
LABEL name="UBI ${UBI_VERSION} | OpenJDK ${OPENJDK_VERSION} | Maven ${MAVEN_VERSION}" \
      release="${MAVEN_VERSION}" \
      maintaner="Dominik Lenoch <dlenoch@redhat.com>" \
      run="docker run --rm -ti <image_name:tag> /bin/bash" \
      summary="Red Hat Messaging QE Docker Image for Maven ${MAVEN_VERSION} with OpenJDK ${OPENJDK_VERSION} on ubi${IMAGE_BASE} minimal"

WORKDIR /opt
RUN curl https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | tar xz
RUN ln -s apache-maven-3.6.3 maven

ENV M2_HOME=/opt/maven
ENV MAVEN_HOME=/opt/maven
ENV PATH=$M2_HOME/bin:$PATH

RUN mkdir /app && groupadd -r maven && useradd -rm -d /home/maven -s /bin/false -g maven maven && chown -R maven:maven /app
WORKDIR /app
USER maven