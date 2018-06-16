Для проверки работы проекта необходимо

клонировать репозиторий,

В каталоге homework11_networks_tunnels/1 есть 3 файла 

```
emergency.key
Vagrantfile_tap
Vagrantfile_tun
```

из каталога homework11_networks_tunnels/1 выполнить переименование соответствующего файла Vagrantfile

и выполнить `vagrant up`

В процессе провижинга будут развернуты 2 виртуальные машины - centralRouter и office1Router,

на роутерах будет установлен openvpn и iperf, также будет скопирован файл ключа emergency.key и 

созданы конфигурационные файлы openvpn

В конце развертывания iperf выполнить тестирование скорости соединения.

В результате приходим к выводу, что скорость передачи на tun выше, чем на tap:


```
    office1Router: Network speed on tap interface
    office1Router: ------------------------------------------------------------
    office1Router: Client connecting to 10.10.10.1, TCP port 5001
    office1Router: TCP window size: 45.0 KByte (default)
    office1Router: ------------------------------------------------------------
    office1Router: [  3] local 10.10.10.2 port 59666 connected with 10.10.10.1 port 5001
    office1Router: [ ID] Interval       Transfer     Bandwidth
    office1Router: [  3]  0.0- 5.0 sec  72.9 MBytes   122 Mbits/sec
    office1Router: [  3]  5.0-10.0 sec  71.4 MBytes   120 Mbits/sec
    office1Router: [  3] 10.0-15.0 sec  59.2 MBytes  99.4 Mbits/sec
    office1Router: [  3] 15.0-20.0 sec  64.9 MBytes   109 Mbits/sec
    office1Router: [  3]  0.0-20.0 sec   268 MBytes   112 Mbits/sec
```

```
    office1Router: Network speed on tun interface
    office1Router: ------------------------------------------------------------
    office1Router: Client connecting to 10.10.10.1, TCP port 5001
    office1Router: TCP window size: 76.5 KByte (default)
    office1Router: ------------------------------------------------------------
    office1Router: [  3] local 10.10.10.2 port 35772 connected with 10.10.10.1 port 5001
    office1Router: [ ID] Interval       Transfer     Bandwidth
    office1Router: [  3]  0.0- 5.0 sec  84.1 MBytes   141 Mbits/sec
    office1Router: [  3]  5.0-10.0 sec  82.1 MBytes   138 Mbits/sec
    office1Router: [  3] 10.0-15.0 sec  84.4 MBytes   142 Mbits/sec
    office1Router: [  3] 15.0-20.0 sec  81.4 MBytes   137 Mbits/sec
    office1Router: [  3]  0.0-20.0 sec   332 MBytes   139 Mbits/sec
```
