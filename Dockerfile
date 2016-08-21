FROM debian:testing
MAINTAINER audibleblink

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -qy install git libtool libtool-bin autoconf automake cmake g++ \
            pkg-config unzip libxcb1-dev libevent-dev libglib2.0-dev libperl-dev \
            libreadline-dev libssl-dev libvte-2.91-dev libxcb1-dev libxfce4ui-2-dev

ENV SOURCE /source
VOLUME /tmp

# installs patched version of checkinstall that allows neovim deb creation
WORKDIR $SOURCE
RUN git clone https://github.com/audibleblink/checkinstall.git && \
    cd checkinstall && \
    make && \
    make install

# builds neovim:master and places the deb on the host system at /tmp
WORKDIR $SOURCE
RUN git clone https://github.com/neovim/neovim.git && cd neovim && make

# builds urxvt:24bit and places the deb on the host system at /tmp
WORKDIR $SOURCE
RUN git clone https://github.com/audibleblink/rxvt-unicode-24bit.git urxvt && \
    cd urxvt && \
    ./configure --enable-everything --enable-24-bit-color && \
    make

# add kickoff scripts for each application
WORKDIR $SOURCE
ENTRYPOINT ["/bin/bash", "build"]
ADD build build
# run this image with sudo docker run -v /tmp:/tmp <image_name> <neovim|urxvt>.
