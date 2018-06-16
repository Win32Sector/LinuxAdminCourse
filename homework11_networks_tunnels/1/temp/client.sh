#!/usr/bin/env bash

#Installing packets

setenforce 0

yum install -y epel-release
yum install -y openvpn easy-rsa

#Installing keys

cp -ar /srv/emergency.key /etc/openvpn
cp /srv/client.conf /etc/openvpn
systemctl start openvpn@client
systemctl enable openvpn@client

#Check status

ss -ua | grep openvpn
systemctl status openvpn@client
ip a
