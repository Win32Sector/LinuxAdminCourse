#!/bin/bash
sdx="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf"
for i in $sdx; do
echo "n
p
1


t
fd
w
"| fdisk $i;done
