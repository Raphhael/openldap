#!/bin/bash -xe

# PASSWD

cat /etc/passwd | awk -F: '$3 >= 1000 && $3 < 50000' 
do
    echo "$l" | awk -f user.awk
done


# GROUPS

for l in $(cat /etc/group | awk -F: '$3 >= 1000 && $3 < 50000')
do
    echo "$l" | awk -f group.awk
done
