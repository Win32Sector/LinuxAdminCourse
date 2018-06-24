## Домашнее задание

OSPF
- Поднять три виртуалки
- Объединить их разными vlan
1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

## Задача 1 Поднять OSPF между машинами на базе Quagga

Проверить выполнение можно клонировав себе этот репозиторий 

Затем необходимо из каталога /homework12_network_routing/1

запуcтить `vagrant up`

В результате поднимутся три роутера в структуре как на схеме ниже

<p align="center"><img src="https://raw.githubusercontent.com/Win32Sector/LinuxAdminCourse/master/homework12_networks_routing/1/ospfmap1.png"></p>


<details>
<summary><code>Вывод ip a</code></summary>



</details>

<details>
<summary><code>конфиги /etc/quagga/*</code></summary>



</details>

<details>
<summary><code>вывод tracepath</code></summary>



</details>

## Задача 2 Изобразить ассиметричный роутинг

Для этого, я повесил cost 300 на интерфейс vlan13 роутера R1 как на схеме.

<p align="center"><img src="https://raw.githubusercontent.com/Win32Sector/LinuxAdminCourse/master/homework12_networks_routing/2/ospfmap2.png"></p>

<details>
<summary><code>Вывод ip a</code></summary>


<details>
<summary><code>R1</code></summary>

```
[vagrant@R1 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 84867sec preferred_lft 84867sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:83:bc:45 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::bf10:53fc:cf71:bac1/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ab:9e:63 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5a3e:fdf2:7ae3:7bf1/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:87:a7:82 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe87:a782/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:83:bc:45 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe83:bc45/64 scope link
       valid_lft forever preferred_lft forever
7: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:ab:9e:63 brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feab:9e63/64 scope link
       valid_lft forever preferred_lft forever
```
</details>

<details>
<summary><code>R2</code></summary>

```
[vagrant@R2 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 84895sec preferred_lft 84895sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:c2:64:c4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::6f34:64d3:f2e2:1f0/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:2f:a8:12 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::dbcf:5635:66d8:bf99/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:7d:d3:f8 brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7d:d3f8/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:c2:64:c4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec2:64c4/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:2f:a8:12 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe2f:a812/64 scope link
       valid_lft forever preferred_lft forever
```
</details>

<details>
<summary><code>R3</code></summary>

```
[root@R3 vagrant]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 84976sec preferred_lft 84976sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:37:b3:9e brd ff:ff:ff:ff:ff:ff
    inet6 fe80::1dda:548e:4d68:ecbd/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:1b:ab:b8 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::9f1:6fd:7d74:9cc4/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:3e:05:5e brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe3e:55e/64 scope link
       valid_lft forever preferred_lft forever
6: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:37:b3:9e brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe37:b39e/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:1b:ab:b8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe1b:abb8/64 scope link
       valid_lft forever preferred_lft forever
```
</details>
</details>

<details>
<summary><code>конфиги /etc/quagga/*</code></summary>

[root@R1 vagrant]# cat /etc/quagga/*

<details>
<summary><code>/etc/quagga/daemons</code></summary>

```
zebra=yes
bgpd=no
ospfd=yes
ospf6d=no
ripd=no
ripngd=no
```

</details>

<summary><code>/etc/quagga/ospfd.conf</code></summary>

```
hostname R1

router ospf
    ospf router-id 192.168.12.1
    network 192.168.12.0/30 area 0
    network 192.168.13.0/30 area 0
    network 10.1.0.0/24 area 1
    redistribute connected

interface vlan13
ip ospf cost 300

log file /var/log/quagga/ospfd.log
```

</details>

<summary><code>/etc/quagga/zebra.conf</code></summary>

```
hostname R1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
```

</details>
</details>

<details>
<summary><code>вывод tracepath</code></summary>

Соответственно, траффик от R3 до R1 идет на прямую 

```
root@R3 vagrant]# tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.1.0.1                                              0.601ms reached
 1:  10.1.0.1                                              0.614ms reached
     Resume: pmtu 1500 hops 1 back 1
```

А от R1 до R3 по пути наименьшей стоимости:

```
[vagrant@R1 ~]$ tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.12.2                                          0.511ms
 1:  192.168.12.2                                          0.514ms
 2:  10.3.0.1                                              1.271ms reached
     Resume: pmtu 1500 hops 2 back 2
```

</details>

