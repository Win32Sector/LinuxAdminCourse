#!/usr/bin/env bash

setenforce 0

#Installing packets

yum install -y epel-release
yum install -y openvpn easy-rsa

#Creating CA and server keys

#Service start

systemctl start openvpn@server
systemctl enable openvpn@server

#Check status

systemctl status openvpn@server
ip a


