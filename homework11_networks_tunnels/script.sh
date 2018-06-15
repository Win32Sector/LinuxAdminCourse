#!/usr/bin/env bash

#yum install -y epel-release
#yum install -y openvpn easy-rsa
#cp -ar /usr/share/easy-rsa /srv
cd /usr/share/easy-rsa/3
echo "yes" | /usr/share/easy-rsa/3/easyrsa init-pki
echo "openvpnserver" | /usr/share/easy-rsa/3/easyrsa build-ca nopass
cp -ar /usr/share/easy-rsa/3/pki/ca.crt /etc/openvpn
cp -ar /usr/share/easy-rsa/3/pki/private/ca.key /etc/openvpn
echo "openvpnserver" | /usr/share/easy-rsa/3/easyrsa gen-req server openvpnserver nopass
echo "yes" | /usr/share/easy-rsa/3/easyrsa sign-req server server
/usr/share/easy-rsa/3/easyrsa gen-dh
cp -ar /usr/share/easy-rsa/3/issued/server.crt /etc/openvpn
cp -ar /usr/share/easy-rsa/3/pki/private/server.key /etc/openvpn
cp -ar /usr/share/easy-rsa/3/pki/dh.pem /etc/openvpn
