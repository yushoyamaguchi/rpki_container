FROM ubuntu:20.04

#install lib
RUN apt -y update
RUN apt -y install rsyslog curl wget git gawk libsnmp-dev vim
RUN apt -y install autoconf libtool gawk libreadline-dev libncurses-dev bison flex
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "tzdata tzdata/Areas select Asia" | debconf-set-selections && \
    echo "tzdata tzdata/Zones/Asia select Tokyo" | debconf-set-selections
RUN apt -y install texinfo texi2html libconfig-dev screen uthash-dev
RUN apt -y install iproute2 iputils-ping net-tools nmap traceroute tcpdump
RUN apt -y install systemctl telnet expect
RUN apt -y install build-essential
RUN apt -y install openssl libssl-dev

#build
RUN git clone https://github.com/usnistgov/NIST-BGP-SRx.git
WORKDIR /NIST-BGP-SRx
RUN ./buildBGP-SRx.sh -A -T -X examples 1 -I ; exit 0
WORKDIR /

COPY ./exec_router.sh exec_router.sh


