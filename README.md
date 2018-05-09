Table of Contents
=================

   * [Table of Contents](#table-of-contents)
      * [Linux Administrator course homework #1](#linux-administrator-course-homework-1)
      * [Linux Administrator course homework #2](#linux-administrator-course-homework-2)
      * [Linux Administrator course homework #3](#linux-administrator-course-homework-3)

## Linux Administrator course homework #1

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

Далее нужно было выделить том под /home и под /var

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

Попробовал что такое снапшоты
for i in {1..10}; do touch /home/file_$i;done
lvcreate -L 300M -s -n LogVol03-snap0 /dev/VolGroup00/LogVol03
Удалил часть файлов
Восстановил из снапшота:
lvconvert --merge /dev/VolGroup00/LogVol03-snap0

C btrfs на работе сталкивался в NAS от Synology. Вдруг начались проблемы с производительностью. В рабочий час пик, иногда, утилизация раздела составляла 100% и хранилка зависала намертво и висела по 10-20 минут, после этого, утилизация раздела опять приходила в норму. Поймали ее на том, что в моменты пиковой нагрузки процесс btrfs-cleaner нагружал диски.
Все осложнялось тем, что в этих NAS Linux, но дико урезанный и поставить какой-то iostat на нашу модель нет возможности, да и вообще всяческие *top. Проблему удалось решить выставлением noatime в /etc/fstab, что повысило производительность при максимальной нагрузке где-то на 20% по утилизации диска. 
