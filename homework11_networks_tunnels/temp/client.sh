#!/usr/bin/env bash

#Installing packets

setenforce 0

yum install -y epel-release
yum install -y openvpn easy-rsa

#Installing keys

cp -ar /srv/client.conf /etc/openvpn
cp -ar /srv/ca.crt /etc/openvpn
cp -ar /srv/client.crt /etc/openvpn
cp -ar /srv/client.key /etc/openvpn
cp -ar /srv/ta.key /etc/openvpn


mkdir /var/log/openvpn
sleep 10
systemctl start openvpn@client
systemctl enable openvpn@client

#Check status

ss -ua | grep openvpn
systemctl status openvpn@client
ip a
