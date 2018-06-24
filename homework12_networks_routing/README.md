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
       valid_lft 85789sec preferred_lft 85789sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:fc:8f:78 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e2:c8:e5 brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:4d:b9:3c brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe4d:b93c/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:fc:8f:78 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefc:8f78/64 scope link
       valid_lft forever preferred_lft forever
7: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:e2:c8:e5 brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fee2:c8e5/64 scope link
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
       valid_lft 85826sec preferred_lft 85826sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:86:a4:2b brd ff:ff:ff:ff:ff:ff
    inet6 fe80::18dc:36f4:f185:ad74/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:5d:c9:e2 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b4ed:20a9:3edd:3ea1/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:b2:e6:cd brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb2:e6cd/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:86:a4:2b brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe86:a42b/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:5d:c9:e2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe5d:c9e2/64 scope link
       valid_lft forever preferred_lft forever
```

</details>

<details>
<summary><code>R3</code></summary>

```
[vagrant@R3 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85933sec preferred_lft 85933sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:b7:a8:0c brd ff:ff:ff:ff:ff:ff
    inet6 fe80::598b:2f21:35c1:2edd/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:72:de:ab brd ff:ff:ff:ff:ff:ff
    inet6 fe80::f425:f396:426f:53d3/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:23:3a:03 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe23:3a03/64 scope link
       valid_lft forever preferred_lft forever
6: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:b7:a8:0c brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feb7:a80c/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:72:de:ab brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe72:deab/64 scope link
       valid_lft forever preferred_lft forever
```

</details>
</details>

<details>
<summary><code>конфиги /etc/quagga/*</code></summary>

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
<details>
<summary><code>/etc/quagga/ospfd.conf</code></summary>

```
hostname R1

router ospf
    ospf router-id 192.168.12.1
    network 192.168.12.0/30 area 0
    network 192.168.13.0/30 area 0
    network 10.1.0.0/24 area 1
    redistribute connected

log file /var/log/quagga/ospfd.log
```

</details>
<details>
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

[vagrant@R1 ~]$ tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              0.571ms reached
 1:  10.3.0.1                                              0.940ms reached
     Resume: pmtu 1500 hops 1 back 1

[vagrant@R3 ~]$ tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.1.0.1                                              0.393ms reached
 1:  10.1.0.1                                              0.663ms reached
     Resume: pmtu 1500 hops 1 back 1

</details>

<br><br>
**Все network-скрипты и файлы конфигурации quagga 
можно увидеть в каталоге network-scripts**

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
<details>
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
<details>
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

<br><br>
**Все network-скрипты и файлы конфигурации quagga 
можно увидеть в каталоге network-scripts**

## Задача 3 Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

Для этого, я повесил cost 300 на интерфейс vlan13 роутера R1 и роутера R3 как на схеме.

<p align="center"><img src="https://raw.githubusercontent.com/Win32Sector/LinuxAdminCourse/master/homework12_networks_routing/3/ospfmap3.png"></p>

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
       valid_lft 85293sec preferred_lft 85293sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:bc:fb:ca brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e9:80:ae brd ff:ff:ff:ff:ff:ff
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:ab:6a:7c brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feab:6a7c/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:bc:fb:ca brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:febc:fbca/64 scope link
       valid_lft forever preferred_lft forever
7: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:e9:80:ae brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fee9:80ae/64 scope link
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
       valid_lft 85324sec preferred_lft 85324sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:19:0c:37 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5454:89fd:47b5:6286/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:e6:6c:e9 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::efc5:b7de:5c5d:3a41/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:68:5d:50 brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe68:5d50/64 scope link
       valid_lft forever preferred_lft forever
6: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:19:0c:37 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe19:c37/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:e6:6c:e9 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fee6:6ce9/64 scope link
       valid_lft forever preferred_lft forever
```

</details>

<details>
<summary><code>R3</code></summary>

```
[vagrant@R3 ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:c9:c7:04 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85419sec preferred_lft 85419sec
    inet6 fe80::5054:ff:fec9:c704/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:8d:f1:b1 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::bdc6:45f9:a51e:a777/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:cb:3e:56 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b6d7:3e9c:a55d:ec47/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:fb:ab:85 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefb:ab85/64 scope link
       valid_lft forever preferred_lft forever
6: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:8d:f1:b1 brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe8d:f1b1/64 scope link
       valid_lft forever preferred_lft forever
7: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:cb:3e:56 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fecb:3e56/64 scope link
       valid_lft forever preferred_lft forever
```

</details>

</details>

<details>
<summary><code>конфиги /etc/quagga/*</code></summary>

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
<details>
<summary><code>/etc/quagga/ospfd.conf на R1</code></summary>

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

<summary><code>/etc/quagga/ospfd.conf на R3</code></summary>

```
hostname R3

router ospf
    ospf router-id 192.168.13.2
    network 192.168.13.0/30 area 0
    network 192.168.23.0/30 area 0
    network 10.3.0.0/24 area 3
    redistribute connected

interface vlan13
ip ospf cost 300

log file /var/log/quagga/ospfd.log
```

</details>
<details>
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

Соответственно, траффик от R3 до R1 идет через R2

```
[root@R3 vagrant]# tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.23.1                                          0.600ms
 1:  192.168.23.1                                          0.664ms
 2:  10.1.0.1                                              1.350ms reached
     Resume: pmtu 1500 hops 2 back 2
```

А от R1 до R3 тоже идет через R2

```
[vagrant@R1 ~]$ tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.12.2                                          0.549ms
 1:  192.168.12.2                                          0.693ms
 2:  10.3.0.1                                              1.121ms reached
     Resume: pmtu 1500 hops 2 back 2
```

</details>

<br><br>
**Все network-скрипты и файлы конфигурации quagga 
можно увидеть в каталоге network-scripts**
