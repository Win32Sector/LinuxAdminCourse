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
