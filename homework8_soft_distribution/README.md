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
