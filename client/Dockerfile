from ubuntu

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils openssl nano debconf-utils net-tools dnsutils dialog iputils-ping\
    && apt-get autoclean

RUN useradd --password $(echo azerty | openssl passwd -6 -stdin) --create-home --shell /bin/bash user1

COPY ./conf.dpkg /root/settings
COPY ./nslcd.conf /etc/nslcd.conf
COPY ./init.sh /root/init.sh

CMD chmod +x /root/init.sh && /root/init.sh && bash -c "while :; do sleep 1; done"
