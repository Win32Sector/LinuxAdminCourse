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
<p align="center"><img src="https://github.com/Win32Sector/LinuxAdminCourse/blob/master/homework4_Boot/media/centos_install_disk_partitioning.png"></p>

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

Гуглил чего бы такого добавить в initrd, но ничего этакого не нашел, поэтому, решил использовать модуль, который показывал Александр на занятии. 

```
mkdir /usr/lib/dracut/modules.d/01test # создал каталог для скриптов установки модуля
```

И два файла со следующим содержимым:

<details>
<summary><code>module_setup.sh</code></summary>

Скрипт предназначен для установки модуля test.sh

```
#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "${moddir}/test.sh"
}
```

</details>

<details>
<summary><code>test.sh</code></summary>

Сам модуль

```
#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'

Hello! You are in dracut module!

 ___________________
< I'm Tux >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/`\
    \___)=(___/
msgend
sleep 10
echo " continuing...."
```

</details>

Пересоздал initrd командой
`mkinitrd -f -v -a test /boot/initramfs-$(uname -r).img $(uname -r)`

Вывод команды
`lsinitrd -m /boot/initramfs-$(uname -r).img` 

```
Image: /boot/initramfs-3.10.0-693.el7.x86_64.img: 20M
========================================================================
Early CPIO image
========================================================================
drwxr-xr-x   3 root     root            0 May 15 03:14 .
-rw-r--r--   1 root     root            2 May 15 03:14 early_cpio
drwxr-xr-x   3 root     root            0 May 15 03:14 kernel
drwxr-xr-x   3 root     root            0 May 15 03:14 kernel/x86
drwxr-xr-x   2 root     root            0 May 15 03:14 kernel/x86/microcode
-rw-r--r--   1 root     root        17408 May 15 03:14 kernel/x86/microcode/GenuineIntel.bin
========================================================================
Version: dracut-033-502.el7

dracut modules:
bash
<b>test</b>
....
```

Что говорит о том, что наш кастомный модуль был загружен.

Сделаем `reboot`

При перезагрузке видим нашего Тукса

<p align="center"><img src="https://github.com/Win32Sector/LinuxAdminCourse/blob/master/homework4_Boot/media/dracut_custom_module.png"></p>

</details>
