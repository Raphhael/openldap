# exporter une ligne du fichier /etc/passwd au format ldif

BEGIN { FS = ":"; OFS = "" }
{
    if ($3 >= 1000 && $3 < 50000) {
        print "dn: uid=", $1, ",ou=People,dc=cyberus,dc=fr"
        print "objectClass: posixAccount"
        print "objectClass: shadowAccount"
        print "objectClass: inetOrgPerson"
        print "cn: ", $1
        print "uid: ", $1
        print "sn: ", $1
        print "uidNumber: ", $3
        print "gidNumber: ", $4
        print "homeDirectory: ", $6
        print "loginShell: ", $7
        print ""
    }
}
