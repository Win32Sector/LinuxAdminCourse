## Linux Administrator course homework #4

<pre>
Работа с загрузчиком
1. Попасть в систему без пароля несколькими способами
2. Установить систему с LVM, после чего переименовать VG
3. Добавить модуль в initrd

4(*). Сконфигурировать систему без отдельного раздела с /boot, а только с LVM
Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/
PV необходимо инициализировать с параметром --bootloaderareasize 1m
</pre>

<details>
<summary><code>Попасть в систему без пароля несколькими способами</code></summary>

1. Прописать в конфигурации GRUB параметр rd.break. Этот параметр останавливает загрузку на стадии initramfs и позволит сбросить пароль пользователя, например, root
2. Загрузиться с LiveCD  в Troubleshooting - Rescue a CentOS system
3. Добавить в параметры загрузки вместо ro, rw init=/bin/sh 

</details>

<details>
<summary><code>Установить систему с LVM, после чего переименовать VG</code></summary>

1. Установил CentOS 7 с образа и создал разделы:
<p align="center"><img width=60% src=""></p>

2. Переименовал VG командой `vgrename centos centos_renamed`
3. Переименовал vg с именем centos на centos_renamed в файлах 

```
/etc/fstab
/etc/default/grub
/boot/grub2/grub.cfg
```
4. Собрал новый initramfs.img, чтобы он знал, что изменилось имя VG 

```
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

5. Перезагрузил систему.
</details>
