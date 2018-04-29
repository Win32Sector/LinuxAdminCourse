Table of Contents
=================

   * [Table of Contents](#table-of-contents)
      * [Linux Administrator course homework #1](#linux-administrator-course-homework-1)
      * [Linux Administrator course homework #2](#linux-administrator-course-homework-2)

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

My file `.config` you can find in this repo near this README.md file.

## Linux Administrator course homework #2


"Сломал" один из дисков, удалив его с помощью fdisk
<details>
<summary>Вывод <code>mdadm --detail /dev/md0</code><summary>
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
Создал и подключил его снова с помощью 
```
mdadm /dev/md0 --add /dev/sdc1
```
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
