FROM ubuntu:focal

CMD ["/bin/bash"]
RUN apt -y update
RUN apt -y install iproute2 iputils-ping net-tools build-essential 
RUN apt -y install ca-certificates curl gnupg lsb-release
RUN curl -fsSL https://packages.nlnetlabs.nl/aptkey.asc |  gpg --dearmor -o /usr/share/keyrings/nlnetlabs-archive-keyring.gpg
RUN echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nlnetlabs-archive-keyring.gpg] https://packages.nlnetlabs.nl/linux/debian \
$(lsb_release -cs) main" | tee /etc/apt/sources.list.d/nlnetlabs.list > /dev/null
RUN apt update
RUN apt -y install routinator
RUN routinator-init
RUN systemctl enable --now routinator


#CMD ["/bin/bash"]