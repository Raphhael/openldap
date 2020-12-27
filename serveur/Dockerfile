from debian:stable-slim

RUN apt-get update

RUN apt-get install -y openssl nano net-tools tcpdump iputils-ping \
    && apt-get autoclean

ADD ./install.sh /root/install.sh
ADD ./ldif /root/ldif

CMD chmod +x /root/install.sh && /root/install.sh && bash -c "while :; do sleep 1; done"

EXPOSE 389/tcp 636/tcp
