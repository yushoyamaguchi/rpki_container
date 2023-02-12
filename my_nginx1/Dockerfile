FROM ubuntu:20.04

RUN apt -y update
RUN apt -y install iproute2 iputils-ping net-tools systemctl
RUN apt -y install tcpdump vim strace less
RUN apt -y install nginx openssl libnss3-tools
#systemd入れたらなんかバグったのでjournalctl使えない


RUN apt -y update

COPY ./nginx_start1.sh nginx_start1.sh



