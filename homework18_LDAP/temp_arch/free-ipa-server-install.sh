#!/usr/bin/expect

spawn ipa-server-install

expect "Do you want to configure integrated DNS (BIND)? \[no\]: "
send "yes\r"

expect "Server host name \[centralServer\]: "
send "centralserver.mydomain.test\r"

expect "Please confirm the domain name \[mydomain.test\]: "
send "\r"

expect "Please provide a realm name \[MYDOMAIN.TEST\]: "
send "\r"

expect "Directory Manager password: "
send "12345678\r"

expect "Password (confirm): "
send "12345678\r"

expect "IPA admin password: "
send "87654321\r"

expect "Password (confirm): "
send "87654321\r"

expect "Do you want to configure DNS forwarders? \[yes\]: "
send "\r"

expect "Do you want to configure these servers as DNS forwarders? \[yes\]: "
send "\r"

expect "Enter an IP address for a DNS forwarder, or press Enter to skip: "
send "\r"

expect "Do you want to search for missing reverse zones? \[yes\]: "
send "\r"

expect "Do you want to create reverse zone for IP 192.168.0.2 \[yes\]: "
send "\r"

expect "Please specify the reverse zone name \[0.168.192.in-addr.arpa.\]: "
send "\r"

expect "Continue to configure the system with these values? \[no\]: "
send "yes\r"

interact
