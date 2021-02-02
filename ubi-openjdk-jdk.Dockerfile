ARG UBI_VERSION=7
ARG UBI_VERSION_MINOR=9
ARG OPENJDK_VERSION=8

ARG IMAGE_BASE=registry.access.redhat.com/ubi${UBI_VERSION}/ubi-minimal

FROM ${IMAGE_BASE}:${UBI_VERSION}.${UBI_VERSION_MINOR} AS ubi
LABEL name="UBI ${UBI_VERSION} | OpenJDK ${OPENJDK_VERSION} devel" \
      release="${OPENJDK_VERSION}" \
      maintaner="Dominik Lenoch <dlenoch@redhat.com>" \
      run="docker run --rm -ti <image_name:tag> /bin/bash" \
      summary="Red Hat Messaging QE Docker Image for OpenJDK on ubi${UBI_VERSION} minimal"

FROM ubi as ubi_jdk11
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
ENV OPENJDK_PACKAGE=java-11-openjdk-devel

FROM ubi as ubi_jdk8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV OPENJDK_PACKAGE=java-1.8.0-openjdk-devel

FROM ubi_jdk${OPENJDK_VERSION} AS final
RUN microdnf install "${OPENJDK_PACKAGE}" -y --nodocs && microdnf clean all
