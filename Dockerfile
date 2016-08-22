FROM debian:testing
MAINTAINER audibleblink

ENV DEBIAN_FRONTEND noninteractive
ENV SOURCE /source
VOLUME /tmp

RUN apt-get update && \
    apt-get -qy install \
                autoconf \
                automake \
                cmake \
                g++ \
                git \
                libev-dev \
                libevent-dev \
                libglib2.0-dev \
                libpango1.0-dev \
                libperl-dev \
                libreadline-dev \
                libssl-dev \
                libstartup-notification0-dev \
                libtool \
                libtool-bin \
                libvte-2.91-dev \
                libxcb1-dev \
                libxcb-cursor-dev \
                libxcb-icccm4-dev \
                libxcb-keysyms1-dev \
                libxcb-randr0-dev \
                libxcb-util0-dev \
                libxcb-xinerama0-dev \
                libxcb-xkb-dev \
                libxkbcommon-dev \
                libxkbcommon-x11-dev \
                libyajl-dev \
                pkg-config \
                unzip


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


# builds i3 and places the deb on the host system at /tmp
WORKDIR $SOURCE
RUN git clone https://www.github.com/Airblader/i3 i3-gaps && \
    cd i3-gaps && \
    git checkout gaps && \
    make


# add kickoff scripts for each application
WORKDIR $SOURCE
ENTRYPOINT ["/bin/bash", "build"]
ADD build build
# run this image with sudo docker run -v /tmp:/tmp <image_name> <neovim|urxvt>.
