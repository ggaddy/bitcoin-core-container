FROM registry.fedoraproject.org/fedora:34

# install dependencies
RUN dnf install -y boost-devel && \
  dnf install -y libevent-devel && \
  dnf install -y miniupnpc-devel && \
  dnf install -y libnatpmp-devel && \
  dnf install -y sqlite-devel && \
  dnf install -y zeromq-devel && \
  dnf install -y openssl-devel && \
  dnf install -y gcc-c++ && \
  dnf install -y libtool && \
  dnf install -y make && \
  dnf install -y autoconf && \
  dnf install -y automake && \
  dnf install -y python && \
  dnf install -y git && \
  dnf install -y bash && \
  dnf install -y diffutils
RUN dnf update -y && dnf upgrade -y

# download bitcoin core code
RUN mkdir -p /opt/bitcoin
RUN git clone https://github.com/bitcoin/bitcoin.git  /opt/bitcoin

# configure and make bitcoind
RUN cd /opt/bitcoin && /opt/bitcoin/autogen.sh
RUN cd /opt/bitcoin && /opt/bitcoin/configure --disable-wallet --without-gui --with-incompatible-bdb --enable-upnp-default --enable-natpmp-default
RUN cd /opt/bitcoin && make -j4 && make install

# cleanup dnf
RUN dnf clean all -y
RUN rm -rf /var/cache/dnf

# cleanup bitcoin github code
RUN rm -rf /opt/bitcoin

ENTRYPOINT ["bitcoind"]
