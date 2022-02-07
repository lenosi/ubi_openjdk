ARG UBI_VERSION=7
ARG UBI_VERSION_MINOR=9
ARG OPENJDK_VERSION=8

ARG IMAGE_BASE=registry.access.redhat.com/ubi${UBI_VERSION}/ubi-minimal

FROM ${IMAGE_BASE}:${UBI_VERSION}.${UBI_VERSION_MINOR} AS ubi
LABEL name="UBI ${UBI_VERSION} | OpenJDK ${OPENJDK_VERSION} JRE headless" \
      release="${OPENJDK_VERSION}" \
      maintaner="Dominik Lenoch <dlenoch@redhat.com>" \
      run="docker run --rm -ti <image_name:tag> /bin/bash" \
      summary="Red Hat Messaging QE Docker Image for OpenJDK on ubi${UBI_VERSION} minimal"

FROM ubi AS ubi_jdk11
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV OPENJDK_PACKAGE=java-11-openjdk-headless

FROM ubi AS ubi_jdk8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV OPENJDK_PACKAGE=java-1.8.0-openjdk-headless

FROM ubi_jdk${OPENJDK_VERSION} AS final
RUN microdnf --setopt=tsflags=nodocs install ${OPENJDK_PACKAGE} -y && microdnf clean all
