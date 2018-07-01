## Linux Administrator course homework #13

### Домашнее задание
настраиваем split-dns
взять стенд https://github.com/erlong15/vagrant-bind
добавить еще один сервер client2
завести в зоне dns.lab 
имена

web1 - смотрит на клиент1
web2 смотрит на клиент2

<details>
<summary><code>named.dns.lab</code></summary>



```
$TTL 3600
$ORIGIN dns.lab.
@               IN      SOA     ns01.dns.lab. root.dns.lab. (
                            2711201407 ; serial
                            3600       ; refresh (1 hour)
                            600        ; retry (10 minutes)
                            86400      ; expire (1 day)
                            600        ; minimum (10 minutes)
                        )

                IN      NS      ns01.dns.lab.
                IN      NS      ns02.dns.lab.

; DNS Servers
ns01            IN      A       192.168.50.10
ns02            IN      A       192.168.50.11

; Clients
web1            IN      A       192.168.50.15
web2            IN      A       192.168.50.25
```

</details>

завести еще одну зону newdns.lab
завести в ней запись
www - смотрит на обоих клиентов


<details>
<summary><code>named.newdns.lab</code></summary>

```
$TTL 3600
$ORIGIN newdns.lab.
@               IN      SOA     ns01.newdns.lab. root.newdns.lab. (
                            2711201407 ; serial
                            3600       ; refresh (1 hour)
                            600        ; retry (10 minutes)
                            86400      ; expire (1 day)
                            600        ; minimum (10 minutes)
                        )

                IN      NS      ns01.newdns.lab.
                IN      NS      ns02.newdns.lab.

; DNS Servers
ns01            IN      A       192.168.50.10
ns02            IN      A       192.168.50.11

; Clients
www            IN      A       192.168.50.15
www            IN      A       192.168.50.25
```
</details>

настроить split-dns
клиент1 - видит обе зоны, но в зоне dns.lab только web1
клиент2 видит только dns.lab


<details>
<summary><code>master-named.conf</code></summary>

```
options {

    // network 
	listen-on port 53 { 192.168.50.10; 127.0.0.1; };
	listen-on-v6 port 53 { ::1; };

    // data
	directory 	"/var/named";
	dump-file 	"/var/named/data/cache_dump.db";
	statistics-file "/var/named/data/named_stats.txt";
	memstatistics-file "/var/named/data/named_mem_stats.txt";

    // server
	recursion yes;
	allow-query     { any; };
    allow-transfer { any; };
    
    // dnssec
	dnssec-enable yes;
	dnssec-validation yes;

    // others
	bindkeys-file "/etc/named.iscdlv.key";
	managed-keys-directory "/var/named/dynamic";
	pid-file "/run/named/named.pid";
	session-keyfile "/run/named/session.key";
};

logging {
        channel default_debug {
                file "data/named.run";
                severity dynamic;
        };
};

// RNDC Control for client
key "rndc-key" {
    algorithm hmac-md5;
    secret "GrtiE9kz16GK+OKKU/qJvQ==";
};
controls {
        inet 192.168.50.10 allow { 192.168.50.15; } keys { "rndc-key"; }; 
};

acl external { 192.168.50.25; localhost; };

acl internal { key rndc-key; 192.168.50.10; 192.168.50.11; 192.168.50.15;  localhost; };


view external {

    match-clients { external; };

    allow-recursion { any; };

    // lab's zone
    zone "dns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/etc/named/named.dns.lab";
    };

    // lab's zone reverse
    zone "50.168.192.in-addr.arpa" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/etc/named/named.dns.lab.rev";
    };

    // lab's ddns zone
    zone "ddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/etc/named/named.ddns.lab";
    };
};

view internal {

    match-clients { internal; };

    allow-recursion { any; };

    // ZONE TRANSFER WITH TSIG
    include "/etc/named.zonetransfer.key";
    server 192.168.50.11 {
        keys { "zonetransfer.key"; };
    };

    // zones like localhost
    include "/etc/named.rfc1912.zones";
    // root's DNSKEY
    include "/etc/named.root.key";

    // root zone
    zone "." IN {
            type hint;
            file "named.ca";
    };

    // lab's zone
    zone "dns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/etc/named/named.newdns1.lab";
    };

    // lab's ddns zone
    zone "ddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/etc/named/named.newddns1.lab";
    };

    // newdnslab's zone
    zone "newdns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/etc/named/named.newdns.lab";
    };

    // newdnslab's zone reverse
    zone "50.168.192.in-addr.arpa" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        file "/etc/named/named.newdns.lab.rev";
    };

    // newdnslab's ddns zone
    zone "newddns.lab" {
        type master;
        allow-transfer { key "zonetransfer.key"; };
        allow-update { key "zonetransfer.key"; };
        file "/etc/named/named.newddns.lab";
    };
};


```

</details>
