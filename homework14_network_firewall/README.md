Домашнее задание
Сценарии iptables
1) реализовать knocking port
- centralRouter может попасть на ssh inetrRouter через knock скрипт
пример в материалах
2) добавить inetRouter2, который виден(маршрутизируется) с хоста
3) запустить nginx на centralServer
4) пробросить 80й порт на inetRouter2 8080
5) дефолт в инет оставить через inetRouter

Выполнение домашней работы

Выполненная работа в файле Vagrantfile

Чтобы проверить работу, необходимо скопировать файл Vagrantfile к себе на компьютер 

и выполнить `vagrant up` (Должен быть установлен Vagrant)



<details>
<summary><code>реализовать knocking port</code></summary>

Взял скрипт и правила iptables Из примера материалов к уроку.
Вагрант кладет iptables_inetrouter.rules на inetRouter и делает iptables-restore
Чтобы попасть с помощью knocking port на inetrouter, необходимо зайти на centralRouter 
и выполнить скрипт `/vagrant/knock.sh 192.168.255.1 8881 7777 9991`. Затем, в течение 30 секунд можно 
будет покдлючиться по ssh с centralRouter на inetRouter `ssh vagrant@192.168.255.1` пароль - vagrant

</details>

<details>
<summary><code>2-5</code></summary>

Сначала я сделал public через бридж, но выбор адаптера - не лучший выбор, 
поэтому, далее было придумано пробросить через локалхост

При выполнении `vagrant up` выполняется установка nginx на centralServer,
с помощью правил, указанных в файле iptables_inetrouter2.rules, на inetRouter2 
добавляются правила, пробрасывающие порт 80 на inetRouter2 8080

Дефолт в инет оставлен через inetRouter.

</details>
