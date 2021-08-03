FROM registry.fedoraproject.org/fedora:34
# install dependencies
RUN dnf install boost-devel libevent-devel miniupnpc-devel libnatpmp-devel sqlite-devel zeromq-devel -y
RUN dnf install gcc-c++ libtool make autoconf automake python git -y

# configure bitcoin core
RUN git clone https://github.com/bitcoin/bitcoin.git  /opt
RUN cd /opt/bitcoin && ./autogen.sh
RUN cd /opt/bitcoin && ./configure --disable-wallet --without-gui --with-incompatible-bdb --enable-upnp-default --enable-natpmp-default
RUN cd /opt/bitcoin && make -j 4 && make install

# cleanup dnf
RUN dnf clean all -y

ENTRYPOINT ["/bin/bitcoind"]
