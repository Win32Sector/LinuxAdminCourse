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
