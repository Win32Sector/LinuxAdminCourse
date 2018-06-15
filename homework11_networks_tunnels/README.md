Для проверки работы проекта необходимо

клонировать репозиторий,

из каталога homework11_networks_tunnels установить плагин

`vagrant plugin install vagrant-vbguest`

Затем, находясь в каталоге homework11_networks_tunnels выполнить

`vagrant up centralRouter office1Router`



В процессе провижинга будут установлены гостевые дополнения для работы shared_folders Virtualbox,

будут сгенерированы ключи сервера и клиента, переданы на клиента и запущены сервисы.

На centralRouter, который является сервером - все ок, 

Но, на клиенте office1Router, в логе /var/log/openvpn/openvpn-client.log получаю ошибки с конфигурацией сети

```
Fri Jun 15 12:17:49 2018 TCP/UDP: Preserving recently used remote address: [AF_INET]10.10.0.1:1194
Fri Jun 15 12:17:49 2018 Socket Buffers: R=[212992->212992] S=[212992->212992]
Fri Jun 15 12:17:49 2018 UDP link local (bound): [AF_INET][undef]:1194
Fri Jun 15 12:17:49 2018 UDP link remote: [AF_INET]10.10.0.1:1194
Fri Jun 15 12:18:49 2018 TLS Error: TLS key negotiation failed to occur within 60 seconds (check your network connectivity)
Fri Jun 15 12:18:49 2018 TLS Error: TLS handshake failed
Fri Jun 15 12:18:49 2018 SIGUSR1[soft,tls-error] received, process restarting
Fri Jun 15 12:18:49 2018 Restart pause, 80 second(s)
```

