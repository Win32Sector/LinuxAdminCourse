## Linux Administrator course homework #17

Внутри каталога homework17_Ansible сделать `vagrant up` 

Поднимется машина с именем vagrant1.

1. Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни

Особенностью этой машины будет то, что согласно первой задачи, 
будут созданы 2 пользователя - vasya и petya, а также группа admin.

vasya член группы admin, petya - нет

С помощью pam_script обеспечивается, чтобы члены группы admin
могли логиниться по выходным и праздникам, указанным в файле Holidays.

2. Дать конкретному пользователю права рута

Не знаю, что именно имелось в виду, но я придумал дать возможность получения su привилегий определенному пользователю через PAM

Для этого, в файл /etc/pam.d/su добавляются строки

```
account         sufficient      pam_succeed_if.so user = vasya use_uid quiet

account         required        pam_succeed_if.so user notin root:vagrant:vasya
```

Соответственно, пользователь vasya получает возможность использовать повышение привилегий через su root.

Еще, я добавил привилегии cap_sys_admin для пользователя vasya через файл /etc/pam.d/su

```
$ vagrant ssh vagrant1
[vagrant@vagrant1 ~]$ su - vasya
Password:
Last login: Thu Jul 12 14:06:24 UTC 2018 on pts/0
[vasya@vagrant1 ~]$ capsh --print
Current: = cap_sys_admin+i
Bounding set =cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_linux_immutable,cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw,cap_ipc_lock,cap_ipc_owner,cap_sys_module,cap_sys_rawio,cap_sys_chroot,cap_sys_ptrace,cap_sys_pacct,cap_sys_admin,cap_sys_boot,cap_sys_nice,cap_sys_resource,cap_sys_time,cap_sys_tty_config,cap_mknod,cap_lease,cap_audit_write,cap_audit_control,cap_setfcap,cap_mac_override,cap_mac_admin,cap_syslog,35,36
Securebits: 00/0x0/1'b0
 secure-noroot: no (unlocked)
 secure-no-suid-fixup: no (unlocked)
 secure-keep-caps: no (unlocked)
uid=1001(vasya)
gid=1002(vasya)
groups=1001(admin),1002(vasya)

```
