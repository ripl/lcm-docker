# Parameters
ARG REPO_NAME="lcm-docker"
ARG DESCRIPTION="Contains the LCM (Lightweight Communications and Marshalling) library"
ARG MAINTAINER="Matthew Walter (mwalter@ttic.edu)"

ARG UBUNTU_VERSION=20.04

# Base image
#FROM nvidia/opengl:1.0-glvnd-devel-ubuntu$UBUNTU_VERSION
FROM ubuntu:$UBUNTU_VERSION

ARG TARGETPLATFORM

# Ubuntu version
#ENV UBUNTU_DISTRIB_CODENAME "focal"
ARG DEBIAN_FRONTEND=noninteractive

# set default LCM_DEFAULT_URL
ENV LCM_IP "239.255.76.67"
ENV LCM_PORT "7667"
ENV LCM_TTL "1"
ENV LCM_DEFAULT_URL "udpm://$LCM_IP:$LCM_PORT?ttl=$LCM_TTL"
RUN echo "export LCM_DEFAULT_URL=udpm://\$LCM_IP:\$LCM_PORT?ttl=\$LCM_TTL" >> /etc/bash.bashrc

# set default installation dir
ENV LCM_INSTALL_DIR "/usr/local/lib"

# update apt lists and install system libraries, then clean the apt cache
RUN apt-get update && apt-get install -y \
    wget \
    cmake \
    g++ \
    libglib2.0-dev \
    python3-dev \
    unzip \
    openjdk-8-jdk \
    locales \
    # clean the apt cache
    && rm -rf /var/lib/apt/lists/*

# Call locale-gen
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set the Kernel UDP buffer size to 10MB
RUN echo 'net.core.rmem_max=10485760' >> /etc/sysctl.conf
RUN echo 'net.core.rmem_default=10485760' >> /etc/sysctl.conf

# set default LCM_VERSION
ENV LCM_VERSION '1.5.0'

# On at least arm/v7, wget throws an error stating that
# it can not verify github.com's certificate
# RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
#         update-ca-certificates -f; \
#     fi


# CMake is unable to find glib-2.0 libraries 
# using the LCM-provided cmake/FindGLib2.cmake
#RUN if [ "$TARGETPLATFORM" = "linux/arm/v7" ]; then \
#ENV GLIB_PATH=/usr/lib/arm-linux-gnueabihf/
#ENV Python_LIBRARY=/usr/lib/arm-linux-gnueabihf/libpython3.8.so
#    fi

# install LCM
RUN \
# pull lcm
    # Zip files are prepended with 'v'
    wget https://github.com/lcm-proj/lcm/archive/refs/tags/v$LCM_VERSION.zip && \
    # open up the source
    unzip v$LCM_VERSION.zip && \
    # configure, build, install, and configure LCM
    cd lcm-$LCM_VERSION && mkdir build && cd build && cmake ../ && make install && ldconfig && \
    # delete source code
    cd / && rm -rf v$LCM_VERSION.zip lcm-$LCM_VERSION

# configure pkgconfig to find LCM
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LCM_INSTALL_DIR/pkgconfig