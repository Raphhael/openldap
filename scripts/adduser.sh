#!/bin/bash -e

[ $# -eq 0 ] && echo "Syntaxe : $0 filename" && exit 1

while true
do
	read -p "Nom de l'utilisateur : " username 
	read -p "User ID : " gid
	read -p "Group ID : " uid
	read -p "Password : " pwd
	cat >> "$1" << eof
dn: uid=${username,,},ou=People,dc=cyberus,dc=fr
objectClass: posixAccount
objectClass: shadowAccount
objectClass: inetOrgPerson
cn: $username
uid: $username
sn: $username
uidNumber: $uid
gidNumber: $gid
homeDirectory: /home/$username
userPassword: {CRYPT}$(echo pwd | openssl passwd -stdin -5)


eof
done
