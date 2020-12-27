#!/bin/bash -xe

dpkg-reconfigure dialog

debconf-set-selections /root/settings

while [ ! -f "/etc/ldap/CA/CA.crt" ]
do
    sleep 1
done

apt-get -y install libpam-ldapd

sed -i '/TLS_CACERT/c\TLS_CACERT \/etc\/ldap\/CA\/CA.crt' /etc/ldap/ldap.conf

chmod 400 /etc/nslcd.conf

service nslcd restart 

[ $(getent passwd |grep 10000 |wc -l) -ge 1 ] && echo Ca a marché
