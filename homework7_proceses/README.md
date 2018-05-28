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
