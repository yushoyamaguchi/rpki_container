FROM ubuntu:20.04

RUN apt -y update
RUN apt -y install iproute2 iputils-ping net-tools systemctl nmap
RUN apt -y install tcpdump vim strace less certbot python3-certbot-nginx
RUN apt -y install nginx openssl libnss3-tools
#systemd入れたらなんかバグったのでjournalctl使えない


RUN apt -y update

COPY ./nginx_lets1.sh nginx_lets1.sh



