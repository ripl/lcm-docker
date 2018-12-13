# Base image
FROM ripl/lcm:environment

# set default LCM_VERSION
ENV LCM_VERSION 'master'

# install LCM
RUN \
# pull lcm
    wget https://github.com/lcm-proj/lcm/archive/$LCM_VERSION.zip && \
# open up the source
    unzip $LCM_VERSION.zip && \
# configure, build, install, and configure LCM
    cd lcm-$LCM_VERSION && mkdir build && cd build && cmake ../ && make install && ldconfig && \
# delete source code
    cd / && rm -rf $LCM_VERSION.zip lcm-$LCM_VERSION

# configure pkgconfig to find LCM
ENV PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$LCM_INSTALL_DIR/pkgconfig
