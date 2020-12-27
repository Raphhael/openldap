#!/bin/bash -xe

DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils

sed -i '/SLAPD_SERVICES/c\SLAPD_SERVICES="ldap:\/\/\/ ldaps:\/\/\/ ldapi:\/\/\/"' /etc/default/slapd

service slapd start

cd ~/ldif

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f change_domain.ldif
ldapmodify -x -w azerty -D cn=admin,dc=cyberus,dc=fr -H ldapi:/// -f init_domain.ldif -c
ldapadd -f fixtures.ldif -w azerty -D cn=admin,dc=cyberus,dc=fr 


mkdir /etc/ldap/tls/
cd /etc/ldap/tls/

# Gen CA
openssl req -new -x509 -newkey rsa:4096 -keyout CA.key -nodes -out /etc/ldap/CA/CA.crt << END
US
California
LA
CertOrg
Security Dept.
cert.org
contact@cert.org
END

# Gen CSR
openssl req -new -newkey rsa:4096 -keyout ldap.key -nodes -out ldap.csr << END
FR
Ile de France
Paris
cyberus, Inc
Division informatique
cyberus.fr
contact@cyberus.fr


END

# Signature
openssl x509 -req -CAkey CA.key -CA /etc/ldap/CA/CA.crt -CAcreateserial -in ldap.csr -out ldap.crt

chown -R openldap .
chown -R openldap /etc/ldap/CA


cd ~

cat > tls.ldif << END
dn: cn=config
changetype: modify
add: olcTLSCACertificateFile
olcTLSCACertificateFile: /etc/ldap/CA/CA.crt
-
add: olcTLSCertificateFile
olcTLSCertificateFile: /etc/ldap/tls/ldap.crt
-
add: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/ldap/tls/ldap.key

END

ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f tls.ldif

sed -i '/TLS_CACERT/c\TLS_CACERT \/etc\/ldap\/CA\/CA.crt' /etc/ldap/ldap.conf

echo -e "127.0.0.1\tcyberus.fr\n" >> /etc/hosts

ldapsearch -LLL -x -H ldaps://cyberus.fr -D cn=admin,dc=cyberus,dc=fr -b dc=cyberus,dc=fr -w azerty
