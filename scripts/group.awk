# exporter une ligne du fichier /etc/group au format ldif
BEGIN { FS = ":"; OFS = "" }
{
    if ($3 >= 1000 && $3 < 50000) {
        print "dn: cn=", $1, ",ou=Groups,dc=cyberus,dc=fr"
        print "objectClass: posixGroup"
        print "cn: ", $1
        print "gidNumber: ", $3
        print ""
    }
}
