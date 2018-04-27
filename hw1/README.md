###########################################

# Linux Administrator course homework #1

###########################################

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

###########################################
