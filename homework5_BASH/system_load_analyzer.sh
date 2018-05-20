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
    cat /var/log/nginx/access.log | cut -d' ' -f1 | sort | uniq -c | sort -nr | tail -n20 >> /tmp/system_load_analize.log
    echo -e "\nСписок процессов mysql\n\n" >> /tmp/system_load_analize.log
    mysql -uroot -p`cat /root/.mysql/root` -e "show processlist" >> /tmp/system_load_analize.log #/root/.mysql/root  это файл с паролем рута, который генерится при создании виртуалки стандартной конфигурации
    mail -s "Отчет о повышенной нагрузке на сервере $HOSTNAME" web-1m592@mail-tester.com < /tmp/system_load_analize.log
else
    exit 0
fi
