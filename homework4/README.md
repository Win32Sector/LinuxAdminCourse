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

1. Прописать в конфигурации GRUB параметр `rd.break`. Этот параметр останавливает загрузку на стадии initramfs и позволит сбросить пароль пользователя, например, root. После загрузки монтируем /sysroot командой `mount -o remount,rw /sysroot` и меняем текущий корень командой `chroot /sysroot`. Далее командой `passwd` меняем пароль учетной записи root. Затем, чтобы это все сохранилось, либо создаем в корне файл .autorelabel командой `touch /.autorelabel` или выполняем команды

```
load_policy -i # загружаем SELinux policy
chcon -t shadow_t /etc/shadow  #Для выбора корректного типа контекста
```


2. Загрузиться с LiveCD  в Troubleshooting - Rescue a CentOS system

3. Добавить в параметры загрузки вместо `ro` пишем  `rw init=/bin/sh` , затем проделать все то же, что и в пункте 1.

</details>

<details>
<summary><code>Установить систему с LVM, после чего переименовать VG</code></summary>

1. Установил CentOS 7 с образа и создал разделы:
<p align="center"><img src="https://github.com/Win32Sector/LinuxAdminCourse/blob/master/homework4/media/centos_install_disk_partitioning.png"></p>

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

<details>
<summary><code>Добавить модуль в initrd</code></summary>



</details>
