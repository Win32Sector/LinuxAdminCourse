#!/usr/bin/env bash

#Installing packets

setenforce 0

yum install -y epel-release
yum install -y openvpn easy-rsa

#Installing keys

mv -ar /srv/client.conf /etc/openvpn
mv -ar /srv/ca.crt /etc/openvpn
mv -ar /srv/client.crt /etc/openvpn
mv -ar /srv/client.key /etc/openvpn



mkdir /var/log/openvpn
systemctl start openvpn@client
systemctl enable openvpn@client

#Check status

ss -ua | grep openvpn
systemctl status openvpn@client
