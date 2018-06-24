Table of Contents
=================

   * [Table of Contents](#table-of-contents)
      * [Linux Administrator course homework #1](#linux-administrator-course-homework-1)
      * [Linux Administrator course homework #2](#linux-administrator-course-homework-2)
      * [Linux Administrator course homework #3](#linux-administrator-course-homework-3)
      * [Linux Administrator course homework #4](#linux-administrator-course-homework-4)
      * [Linux Administrator course homework #5](#linux-administrator-course-homework-5)
      * [Linux Administrator course homework #6](#linux-administrator-course-homework-6)
      * [Linux Administrator course homework #7](#linux-administrator-course-homework-7)
      * [Linux Administrator course homework #8](#linux-administrator-course-homework-8)
      * [Linux Administrator course homework #9](#linux-administrator-course-homework-9)
      * [Linux Administrator course homework #10](#linux-administrator-course-homework-10)
      * [Linux Administrator course homework #11](#linux-administrator-course-homework-11)
      * [Linux Administrator course homework #12](#linux-administrator-course-homework-12)

## Linux Administrator course homework #1

<pre>
Домашнее задание

Делаем собственную сборку ядра
Взять любую версию ядра с kernel.org
Подложить файл конфигурации ядра
Собрать ядро (попутно доставляя необходимые пакеты)
Прислать результирующий файл конфигурации
Прислать списк доустановленных пакетов, взять его можно из /var/log/yum.log
</pre>

In this homework I executed 
```
make && make modules
```
 to build kernel and published my .config file.

I downloaded the latest stable kernel 4.16.41 from kernel.org to my building-folder

It was hard, in first I copied config-file from /boot to my building-folder.

Then I tried `make config`.
but I received so many questions and I did't know what I need answer.

When I tried execute command `make` I received some errors.

I fixed it's with install of gcc, bc, "Development tools". Then, I choiced random answers, when received questions about what modules I want to see in my kernel. And.... command `make` wasn't succeses no one time.

Then, I tried 
```
make menuconfig
``` 
I installed ncurses and ncurses-dev. 
I explored menu and had choice many modules, but kernel not wanted to build again and again. 
When I was very angry and I wanted broke my laptop, I tryed command 
```
make olddefconfig
```
It sets new symbols to their default value.

Then, I executed `make` it was succeses, and `make modules` it was succeses too.

Then I tried to install it with commands 
```
sudo make install && sudo make modules_install
grub2-mkconfig -o /boot/grub/grub.cfg
```

Then I execute `reboot` command and I booted with new kernel!

```
[root@otuslinux linux-otus]# uname -r
4.16.41
```

My file `.config` you can find in this repo in the folder homework1 README.md file.

## Linux Administrator course homework #2

<pre>
Домашнее задание

работа с mdadm.
добавить в Vagrantfile еще дисков
сломать/починить raid
собрать R0/R5/R10 на выбор 
прописать собранный рейд в конф, чтобы рейд собирался при загрузке
создать GPT раздел и 5 партиций

</pre>

Для выполнения скачал репозиторий, который выложил Алексей, поднял из Vagrantfile виртуалку.
Поигрался с fdisk, parted, sfdisk,mdadm.

Добавил в Vagrantfile еще дисков. Посоздавал разные виды RAID-массивов, поломал и починил рейды.

"Сломал" один из дисков, удалив его с помощью fdisk

<details>
<summary>Вывод <code>mdadm --detail /dev/md0</code></summary>

```
[root@otuslinux vagrant]# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Apr 29 06:56:08 2018
        Raid Level : raid5
        Array Size : 1269760 (1240.00 MiB 1300.23 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 5
       Persistence : Superblock is persistent

       Update Time : Sun Apr 29 13:42:23 2018
             State : clean, degraded
    Active Devices : 5
   Working Devices : 5
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 165fad63:be45682d:f4605106:cfcafc0e
            Events : 24

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       -       0        0        1      removed
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       6       8       97        5      active sync   /dev/sdg1
```
</details>
<p>
Создал и подключил его снова с помощью `mdadm /dev/md0 --add /dev/sdc1`
<p>
<details>
<summary>Вывод <code>mdadm --detail /dev/md0</code></summary>

```
[root@otuslinux vagrant]# mdadm --detail /dev/md0
/dev/md0:
           Version : 1.2
     Creation Time : Sun Apr 29 06:56:08 2018
        Raid Level : raid5
        Array Size : 1269760 (1240.00 MiB 1300.23 MB)
     Used Dev Size : 253952 (248.00 MiB 260.05 MB)
      Raid Devices : 6
     Total Devices : 6
       Persistence : Superblock is persistent

       Update Time : Sun Apr 29 13:44:01 2018
             State : clean
    Active Devices : 6
   Working Devices : 6
    Failed Devices : 0
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : otuslinux:0  (local to host otuslinux)
              UUID : 165fad63:be45682d:f4605106:cfcafc0e
            Events : 43

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       7       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       6       8       97        5      active sync   /dev/sdg1
```
</details>
<p>
<details>
      <summary>Прописал собранный рейд в конфиг-файл /etc/mdadm/mdadm.conf, чтобы рейд собирался при загрузке</summary>

```
DEVICE partitions
ARRAY /dev/md0 level=raid5 num-devices=3 metadata=1.2 spares=1 name=otuslinux:0 UUID=91d04df9:c9eaa201:6a1f2e2e:9b1806e3
```

</details>
<p>
Затем удалил машину и прописал в Vagrantfile копирование в виртуалку скрипта создания разделов из подключенных дисков,

А также его запуск и создание рейд-массива из этих разделов, а также создание файла /etc/mdadm/mdadm.conf и 
создание файловой системы на устройстве /dev/md0 и его монтирование в /mnt.

<details>
      <summary>Vagrantfile</summary>

```
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :otuslinux => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.101',
	:disks => {
		:sata1 => {
			:dfile => './sata1.vdi',
			:size => 250,
			:port => 1
		},
		:sata2 => {
      :dfile => './sata2.vdi',
      :size => 250, # Megabytes
			:port => 2
		},
    :sata3 => {
      :dfile => './sata3.vdi',
      :size => 250,
      :port => 3
    }
	}

		
  },
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            	  vb.customize ["modifyvm", :id, "--memory", "1024"]
		  vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]

		  boxconfig[:disks].each do |dname, dconf|
			  unless File.exist?(dconf[:dfile])
				vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
			  end
			  vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]

		  end
          end
    config.vm.provision "file", source: "script.sh", destination: "/home/vagrant/script.sh" 
    box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        yum install -y mdadm smartmontools hdparm gdisk
        cd /home/vagrant && bash ./script.sh
        mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1
        mkdir /etc/mdadm && touch /etc/mdadm/mdadm.conf
        echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
        mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
        mkfs.ext4 /dev/md0
        mount /dev/md0 /mnt
      SHELL

      end
  end
end


```

</details>
<p><p>
Чтобы проверить выполнение работы, достаточно скопировать себе на машину файлы из директории homework2 - Vagrantfile и script.sh,
а затем запустить в этом каталоге команду `vagrant up`


## Linux Administrator course homework #3

<pre>
Домашнее задание

Работа с LVM
на имеющемся образе 
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

уменьшить том под / до 8G
выделить том под /home
выделить том под /var
/var - сделать в mirror
/home - сделать том для снэпшотов
прописать монтирование в fstab
попробовать с разными опциями и разными файловыми системами ( на выбор)
- сгенерить файлы в /home/
- снять снэпшот
- удалить часть файлов
- восстановится со снэпшота
- залоггировать работу можно с помощью утилиты screen

* на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt
</pre>


<details>
<summary><code>уменьшить том под / до 8G</code></summary>

Почитав документацию Red Hat, нашел там упоминание о том, что XFS можно только увеличить, но никак не уменьшить, опечалился и пошел гуглить. Оказалось все очень даже возможно. Не из коробки, но с применением достаточно прочных костылей.

По итогу, для того, чтобы уменьшить том под / до 8G, был добавлен еще один диск, куда был сделан дамп файловой системы с VolGroup00-LogVol00

Процесс выполнения:

```
mkdir /mnt/root_backup
mount /dev/sdf1 /mnt/root_dump
xfsdump /mnt/root_backup/root_dump.tmp /
```

Затем я загрузился с установочного диска в Rescue mode, так как виртуалка никак не хотела грузиться в rescue mode ни с помощью `systemctl isolate rescue.target`, ни с помощью прописывания systemd.unit=rescue.target в параметрах grub.

После загрузки в rescue mode, я зашел в shell и выполнил (не считая поиска lsblk,vgs,lvs, чтобы вспомнить, где оно лежит)

```
lvremove /dev/VolGroup00/LogVol00 - чтобы удалить раздел
lvcreate -L 8G -n LogVol00 VolGroup00 - чтобы создать раздел необходимо размера
mkfs.xfs /dev/VolGroup00/LogVol00
mkdir /mnt/root_backup
mkdir /mnt/root_new
mount /dev/sdf1 /mnt/root_bakup
mount /dev/VolGroup00/LogVol00 /mnt/root_new
xfsrestore /mnt/root_dump.tmp    /mnt/root_new
reboot
```
После перезагрузки увидел результат успешно выплненного  первого задания

```
[root@otuslinux vagrant]# df -hT
Filesystem                      Type      Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00 xfs       8.0G  1.7G  6.3G  22% /
```
</details>

<details>
<summary><code>Далее нужно было выделить том под /home и под /var</code></summary>

```
lvcreate -L 200M -m1 -n LogVol02 VolGroup02 - создал зеркало под /var
mkfs.xfs /dev/VolGroup02/LogVol02

Смонтировал LogVol00 и VolGroup02 во временные папки
mount /dev/VolGroup00/LogVol00 /mnt/root_temp
mount /dev/VolGroup02/LogVol02 /mnt/var_new
Скопировал все содержимое /var
cp -a /mnt/root_temp/var/* /mnt/var_new
Удалил все содержимое /var на текущей файловой системе
rm -rf /mnt/root_temp/var/*

Добавил в /etc/fstab строку 
/dev/mapper/VolGroup02-LogVol02 /var                    xfs     defaults,noatime        0 0

lvcreate -L 300M -n LogVol03 VolGroup00
mkfs.xfs /dev/VolGroup00/LogVol03

Смонтировал VolGroup03 во временную папку
mount /dev/VolGroup00/LogVol03 /mnt/home_new
Скопировал все содержимое /home
cp -a /mnt/root_temp/home/* /mnt/home_new
Удалил все содержимое /home на текущей файловой системе
rm -rf /mnt/root_temp/home/*

Добавил в /etc/fstab строку 
/dev/mapper/VolGroup00-LogVol03 /home                    xfs     defaults        0 0
```
</details>

<details>
<summary><code>Попробовал что такое снапшоты</code></summary>

```
for i in {1..10}; do touch /home/file_$i;done
lvcreate -L 300M -s -n LogVol03-snap0 /dev/VolGroup00/LogVol03
Удалил часть файлов
Восстановил из снапшота:
lvconvert --merge /dev/VolGroup00/LogVol03-snap0
```
</details>
<br><br>
C btrfs на работе сталкивался в NAS от Synology. Вдруг начались проблемы с производительностью. В рабочий час пик, иногда, утилизация раздела составляла 100% и хранилка зависала намертво и висела по 10-20 минут, после этого, утилизация раздела опять приходила в норму. Поймали ее на том, что в моменты пиковой нагрузки процесс btrfs-cleaner нагружал диски.
Все осложнялось тем, что в этих NAS Linux, но дико урезанный и поставить какой-то iostat на нашу модель нет возможности, да и вообще всяческие *top. Проблему удалось решить выставлением noatime в /etc/fstab, что повысило производительность при максимальной нагрузке где-то на 20% по утилизации диска. 

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
<p align="center"><img src="https://raw.githubusercontent.com/Win32Sector/LinuxAdminCourse/master/homework4_Boot/media/centos_install_disk_partitioning.png"></p>

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

<p align="center"><img src="https://raw.githubusercontent.com/Win32Sector/LinuxAdminCourse/master/homework4_Boot/media/dracut_custom_module.png"></p>

</details>

## Linux Administrator course homework #5

Скрипт проверяет текущий уровень LA за минуту и пишет значение LA в лог
Если последние 5+ минут LA больше 2, собирается информация о нагрузке - 
Логи top, iotop, список ip-адресов, с которых было больше всего запросов к nginx, 
mysql processlist, лог отправляется админу на почту.
скрипт нужно добавить в cron для выполнения раз в минуту. 

Я понимаю, что скрипт до умопомрачения прост и там нет регэкспов, циклов, трапов и функций, но, он позволил решить производственную задачу мониторинга LA на серверах.

<details>
<summary>system_load_analyzer.sh</code></summary>

```
#!/usr/bin/env bash

# Скрипт проверяет текущий уровень LA за минуту и пишет значение LA в лог
# Если последние 5+ минут LA больше 2, собирается информация о нагрузке - 
# Логи top, iotop, список ip-адресов, с которых было больше всего запросов к nginx, 
# mysql processlist, лог отправляется админу на почту.
# скрипт нужно добавить в cron для выполнения раз в минуту. 

uptime |  tr -s " " | cut -d' ' -f9 | cut -d, -f1,2  >> /tmp/load_analize.log

SUM=`tail -n5 /tmp/load_analize.log | awk '{ SUM += $1 } END {print SUM}'`

if [[ $SUM -ge 10 ]]
then
    echo -e "\n\nОтчет о повышенной нагрузке $HOSTNAME\n\nВывод uptime\n\n" > /tmp/system_load_analize.log

    echo -e "\nВывод top c сортировкой по использованию MEM\n\n" >> /tmp/system_load_analize.log
    
    top -b -o +%MEM -n 1 | sed 1,6d | head -10 >> /tmp/system_load_analize.log
    
    echo -e "\nВывод top c сортировкой по использованию CPU\n\n" >> /tmp/system_load_analize.log
    
    top -b -o +%CPU -n 1 | sed 1,6d | head -10 >> /tmp/system_load_analize.log
    
    echo -e "\nВывод iotop\n\n" >> /tmp/system_load_analize.log
    
    iotop -b -n 1 | head -20 >> /tmp/system_load_analize.log
    
    echo -e "\nСписок самых активных IP, делающих запросы к нашему NGINX\n\n" >> /tmp/system_load_analize.log
    
    cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n20 >> 
    /tmp/system_load_analize.log
    
    echo -e "\nСписок процессов mysql\n\n" >> /tmp/system_load_analize.log
    
    mysql -uroot -p`cat /root/.mysql/root` -e "show processlist" >> /tmp/system_load_analize.log #/root/.mysql/root  это файл с паролем рута, который генерится при создании виртуалки стандартной конфигурации
    
    mail -s "Отчет о повышенной нагрузке на сервере $HOSTNAME" web-1m592@mail-tester.com < /tmp/system_load_analize.log
else
    exit 0
fi

```
</details>

## Linux Administrator course homework #6

```
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами
```

<details>
<summary>Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig</summary>

```
Сервис работает следующим образом: раз в 30 секунд грепает в конфиге, 
определенном в EnvironmentFile /etc/sysconfig/grep_log, слово, 
определенное там же ( соответствующие переменные $FILE и $WORD)

Сам сервис представлен файлами /libsystemd/system/grep_log.service и grep_log.timer.
Первый описывает функционал сервиса, второй его периодический запуск раз в 30 секунд.
```
</details>

<details>
<summary>Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.</summary>

```
Скрипт доступен в подпапке 2 для этой ДЗ. 
Наглядно видно, как упростилась жизнь администратора, по сравнению с написанием init-скриптов.

[Unit]
Description=Spawn-fsgi service
After=network.target

[Service]
Type=forking
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target

```
</details>

<details>
<summary>Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами</summary>

```
Добавил в файл /lib/systemd/system/httpd@.service в путь к EnvironmentFile, спецификатор %i

```
EnvironmentFile=/etc/sysconfig/httpd-%i
```
Что позволило создать множество файлов конфигурации, 
которые с помощью параметра OPTIONS указывают на различные файлы конфигов, 
например, /etc/httpd/conf/httpd-{new1,new2,new3} 

Запуск производится так:

```
systemctl start httpd@new1.service
```
```
</details>
Все это доступно в виртуальной машине в GCP, запущенной по адресу 35.205.116.131
Вход проискходит так: `ssh -i ~/.ssh/otus otus@35.205.116.131`


## Linux Administrator course homework #7

Скрипт запускает два задания на архивирование каталога var один с наивысшим приоритетом, другой с низшим приоритетом.

В лог пишется date пачала выполнения и окончания выполнения команд архивирования.

Как видно по итогам выполнения, команда, имеющаяя более высокий приоритет, выполняется быстрее, даже будучи запущенной второй.

<details>
<summary>nice_proc.sh</code></summary>

```
#!/usr/bin/env bash

rm -rf /tmp/archive_{low,high}.tar.gz > /dev/null 2>&1
echo "" > nice_log.log

lowpri() {

    echo "[`date`] Start of script with low priority\n" > nice_log.log

    nice -20 tar czvf /tmp/archive_low.tar.gz /boot/* > /dev/null  2>&1

    echo "[`date`] End of script with low priority\n" >> nice_log.log

}

hipri() {

    echo "[`date`] Start of script with high priority\n" >> nice_log.log

    nice --19 tar czvf /tmp/archive_high.tar.gz /boot/* > /dev/null  2>&1

    echo "[`date`] End of script with high priority\n" >> nice_log.log

}

lowpri &
hipri &

cat nice_log.log
```
</details>

## Linux Administrator course homework #8

```
Размещаем свой RPM в своем репозитории
1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
2) создать свой репо и разместить там свой RPM
реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо 

```

Для выполнения домашней работы выбрал собрать пакет nginx с модулем защиты от DDoS [testcookie-nginx-module](https://github.com/kyprizel/testcookie-nginx-module), чтобы получить rpm пакет с уже интегрированным модулем.
 

<details>
<summary>Создать свой RPM</summary>

<br><br>
Процесс выглядел так:

Создал дерево каталогов для сборки
```
rpmdev-setuptree
```
Скачал и установил src-пакет для сборки
```
rpm -Uvh nginx-1.12.0-1.el7.ngx.src.rpm
```
Склонировал с github необходимый модуль
```
git clone https://github.com/kyprizel/testcookie-nginx-module.git
```
Отредактировал SPECS/nginx.spec в части %build добавил опцию
```
--add-dynamic-module=/home/builder/testcookie-nginx-module/
```
Запустил сборку rpm, попросила доустановить зависимости, поставил, потом отредактировал spec-файл в части %files, добавив testcookie-nginx-module.so,

Запустил заново
```
rpmbuild -bb nginx.spec -D 'debug_package %{nil}'
```
(-D 'debug_package %{nil}' - был необходим из-за [бага](https://bugzilla.redhat.com/show_bug.cgi?id=304121) rpm, который висит с 2007 года и при определенных условиях не собирается rpm из-за debug-модуля )

Ииииииии он собрался.

</details>

<details>
<summary>Cоздать свой репо и разместить там свой RPM</summary>

Создал каталог /reposite, скопировал туда свой пакет, выполнил createrepo /reposite

Поставил nginx, добавил в конфиг root /reposite, запустил systemctl start nginx и сделал systemctl enable nginx.

Репо работает здесь: http://35.207.49.222/

Для установки пакетов из него, необходимо создать репо-файл в /etc/yum.repos.d с примерно таким содержимым:

```
[examplerepo]
name=My Repository
baseurl=http://35.207.49.222/
enabled=1
gpgcheck=0
priority=1
```

И поставить пакет yum-priorities для того, чтобы работал параметр, задающий приоритет репозитория.


Затем, попробовать установить пакет nginx.
</details>

## Linux Administrator course homework #9

<details>
<summary><code>Постановка задачи</code></summary>

Дано
Vagrantfile с начальным  построением сети
inetRouter
centralRouter
centralServer

тестировалось на virtualbox


Планируемая архитектура
построить следующую архитектуру

Сеть office1
- 192.168.2.0/26      - dev
- 192.168.2.64/26    - test servers
- 192.168.2.128/26  - managers
- 192.168.2.192/26  - office hardware

Сеть office2
- 192.168.1.0/25      - dev
- 192.168.1.128/26  - test servers
- 192.168.1.192/26  - office hardware


Сеть central
- 192.168.0.0/28    - directors
- 192.168.0.32/28  - office hardware
- 192.168.0.64/26  - wifi

```
Office1 ---\
      -----> Central --IRouter --> internet
Office2----/
```
Итого должны получится следующие сервера
- inetRouter
- centralRouter
- office1Router
- office2Router
- centralServer
- office1Server
- office2Server



Теоретическая часть
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
- проверить нет ли ошибок при разбиении



Практическая часть
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

</details>

Выполнение домашней работы

Выполненная работа в файле Vagrantfile

Чтобы проверить работу, необходимо скопировать файл Vagrantfile к себе на компьютер 

и выполнить `vagrant up` (Должен быть установлен Vagrant)



<details>
<summary><code>Теоретическая часть</code></summary>

- Найти свободные подсети

Если я правильно понял, то это незаполненные промежутки в сетях /24, например

Central

```
192.168.0.16/28
192.168.0.48/28
192.168.0.192/26
```

- Посчитать сколько узлов в каждой подсети, включая свободные

```
/28 подсеть - 15 адресов - 1 бродкаст - 1 шлюз = 13 адресов для хостов
/26 подсеть - 63 адреса  - 1 бродкаст - 1 шлюз = 61 адрес для хостов
/25 подсеть - 127 адресов - 1 бродкаст - 1 шлюз = 125 адресов для хостов
```

- Указать broadcast адрес для каждой подсети

Central-network

```
directors 192.168.0.0/28 - бродкаст - 192.168.0.15
office-hw 192.168.0.32/28 - бродкаст - 192.168.0.47
wi-fi 192.168.0.64/26 - бродкаст - 192.168.0.191
```

Office1-network

```
dev 192.168.2.0/26 - бродкаст - 192.168.2.63
test servers 192.168.2.64/26 - бродкаст - 192.168.2.127
managers 192.168.2.128/26 - бродкаст - 192.168.2.191
hw 192.168.2.192/26 - бродкаст - 192.168.2.255
```

Office2-network

```
dev 192.168.1.0/25 - бродкаст - 192.168.1.127
test servers 192.168.1.128/26 - бродкаст - 192.168.2.191
hw 192.168.2.192/26 - бродкаст - 192.168.2.255
```

- проверить нет ли ошибок при разбиении

Не понял, что тут нужно сделать. Вроде ошибок нет 

</details>

<details>
<summary><code>Практическая часть</code></summary>

Для проверки практической части нужно запустить Vagrantfile и собрать тестовый стенд командой `vagrant up`

Сетевых интерфесов хватило. Насколько понял, можно как в цисках делать сабинтерфейсы, например, я бы сделал 

в роутере centralRouter один интерфейс на сети 192.168.0.X, его бы уже делил на сабинтерфейсы.

Но я ж двоечник, нужно еще две домашки догнать, попробовал в качестве теста на живых машинах - работает, в Vagrant-файл не стал скрипты втыкать для сабинтерфейсов.

</details>

## Linux Administrator course homework #10

Первый и второй пункт выполнены.

В Vagrantfile.

Для проверки работы проекта, нужно клонировать репозиторий и выполнить `vagrant up` из каталога `homework10_networks_basic`.

## Linux Administrator course homework #11


<details>
<summary><code>Домашнее задание</code></summary>
VPN
1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку
</details>

<details>
<summary><code>Первая задача</code></summary>

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

</details>

<details>
<summary><code>Вторая задача</code></summary>

Для проверки работы проекта необходимо

клонировать репозиторий,

В каталоге homework11_networks_tunnels/2 есть 2 файла 

```
client.conf
Vagrantfile
```

из каталога homework11_networks_tunnels/2 выполнить `vagrant up`

В процессе провижинга будет развернута виртуальная машина openvpnserver,

будет установлен openvpn, создан СА, сгенерированы ключи сервера и клиента,

создан конфигурационный файл openvpn сервера, все это можно найти в каталоге

`/etc/openvpn` сервера. Для дальнейшего подключения, необходимо скопировать с виртуальной машины

файлы ca.crt, client.crt и client.key и положить их рядом с конфигом client.conf из каталога данной задачи.

Также, в конфиге client.conf необходимо заменить ip-адрес сервера в опции remote

Адрес можно получить, выполнив `ip a` на виртуальной машине или из вывода ip a в конце скрипта развертывания.

Потом нужно открыть конфиг файл client.conf с помощью любимого openvpn-приложения 

и вы будете подключены к openvpnserver. 

Проверить подключение можно пропинговав адрес 10.0.0.1 со своей машины.


</details>

## Linux Administrator course homework #12

<details>
<summary><code>Домашнее задание</code></summary>


OSPF
- Поднять три виртуалки
- Объединить их разными vlan
1. Поднять OSPF между машинами на базе Quagga
2. Изобразить ассиметричный роутинг
3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

</details>

<details>
<summary><code>Задача 1 Поднять OSPF между машинами на базе Quagga</code></summary>


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
</details>

<details>
<summary><code>Задача 2 Изобразить ассиметричный роутинг</code></summary>

Проверить выполнение можно клонировав себе этот репозиторий

Затем необходимо из каталога /homework12_network_routing/2

запуcтить `vagrant up`

Для выполнения задачи, я повесил cost 300 на интерфейс vlan13 роутера R1 как на схеме.

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
</details>

<details>
<summary><code>Задача 3 Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным</code></summary>

Проверить выполнение можно клонировав себе этот репозиторий

Затем необходимо из каталога /homework12_network_routing/3

запуcтить `vagrant up`

Для выполнения задачи, я повесил cost 300 на интерфейс vlan13 роутера R1 и роутера R3 как на схеме.

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
<details>
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
</details>
</details>
