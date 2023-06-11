FROM ubuntu:20.04

#install lib
RUN apt -y update
RUN apt -y install rsyslog curl wget git gawk libsnmp-dev
RUN apt -y install autoconf libtool gawk libreadline-dev libncurses-dev bison flex
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "tzdata tzdata/Areas select Asia" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/Asia select Tokyo" | debconf-set-selections
RUN apt -y install texinfo texi2html libconfig-dev screen uthash-dev
RUN apt -y install iproute2 iputils-ping net-tools
RUN apt -y install build-essential
RUN apt -y install openssl libssl1.0.0 libssl-dev

#build
RUN git clone https://github.com/usnistgov/NIST-BGP-SRx.git
WORKDIR /NIST-BGP-SRx/srx-crypt-api
RUN ./configure
WORKDIR /NIST-BGP-SRx/quagga-srx
RUN ./configure --enable-vtysh --enable-bgpd
RUN make
RUN make install
WORKDIR /



#RUN apt -y install iproute2 iputils-ping net-tools systemctl rsync
#RUN apt -y install tcpdump nmap traceroute vim




#CMD ["/bin/bash"]
