FROM ubuntu:20.04

RUN apt -y update
RUN apt -y install rsyslog curl wget git
RUN apt -y install build-essential
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN bash /root/.cargo/env
RUN git clone https://github.com/NLnetLabs/routinator.git
WORKDIR /routinator
RUN /root/.cargo/bin/cargo build

WORKDIR /
ENV PATH="/routinator/target/debug:${PATH}"


RUN apt -y install iproute2 iputils-ping net-tools systemctl rsync
RUN apt -y install tcpdump nmap traceroute vim



COPY ./routinator_start1.sh routinator_start1.sh



#CMD ["/bin/bash"]
