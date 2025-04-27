# Как проверить логи ошибок в Arch Linux

Arch Linux, как и большинство современных дистрибутивов Linux, использует `systemd` и его компонент `journald` для централизованного управления логами системы. Основным инструментом для просмотра этих логов является утилита `journalctl`.

Вот руководство по проверке логов ошибок:

## 1. Основной инструмент: `journalctl`

`journalctl` собирает логи из различных источников, включая ядро (kernel), системные службы, стандартные потоки вывода и ошибок процессов, и т.д.

### Просмотр всех логов (с начала последней загрузки)

Чтобы увидеть все логи с момента последней загрузки системы, выполните:

sudo journalctl -b -p 3 | sort | uniq

```sudo journalctl -b | grep -iE 'error|failed|warn|invalid|bad|unable' | gawk '!seen[$0]++'```

```sudo journalctl -b -p 4 | gawk '!seen[$0]++'```
```bash
journalctl -b
-b (или --boot): Показывает сообщения только для текущей загрузки. Без этого флага journalctl покажет все сохраненные логи, что может быть очень много.
Фильтрация по приоритету (Ошибки и выше)
Самый важный флаг для поиска ошибок - это -p (или --priority). Приоритеты варьируются от 0 (emerg) до 7 (debug). Чтобы увидеть только ошибки и сообщения с более высоким приоритетом (critical, alert, emergency):

Bash

journalctl -b -p err
Или можно указать числовой код приоритета (3 для err):

Bash

journalctl -b -p 3
Основные уровни приоритета:
0: emerg (Система неработоспособна)
1: alert (Требуется немедленное действие)
2: crit (Критические состояния)
3: err (Ошибки)
4: warning (Предупреждения)
5: notice (Важные уведомления)
6: info (Информационные сообщения)
7: debug (Отладочные сообщения)
Указав -p err, вы увидите сообщения с приоритетами err, crit, alert, emerg.

Просмотр логов ядра (Kernel Ring Buffer / dmesg)
Часто ошибки, связанные с оборудованием или драйверами, попадают в логи ядра.

Bash

journalctl -b -k
# или
journalctl -b --dmesg
-k (или --dmesg): Показывает только сообщения ядра.
Фильтрация по службе (Unit)
Если вы подозреваете, что ошибки вызывает конкретная служба (например, sshd или nginx), вы можете отфильтровать логи для этой службы:

Bash

journalctl -b -u имя_службы.service
Пример для sshd:

Bash

journalctl -b -u sshd.service -p err
Эта команда покажет ошибки службы sshd за текущую загрузку.

Фильтрация по времени
Можно просматривать логи за определенный период времени с помощью флагов -S (--since) и -U (--until):

Bash

# Ошибки за последний час
journalctl -p err --since "1 hour ago"

# Ошибки со вчерашнего дня
journalctl -p err --since "yesterday" --until "today"

# Ошибки за конкретную дату
journalctl -p err --since "2025-04-03 10:00:00" --until "2025-04-03 18:00:00"
Просмотр логов предыдущих загрузок
Если проблема возникла до последней перезагрузки:

Посмотреть список доступных загрузок:

Bash

journalctl --list-boots
Вывод покажет смещение (например, -1, -2) и ID каждой загрузки.

Просмотреть логи конкретной загрузки:

Используя смещение (например, -1 для предыдущей загрузки):
Bash

journalctl -b -1 -p err
Используя ID загрузки из списка выше:
Bash

journalctl -b ID_загрузки -p err
Слежение за логами в реальном времени
Чтобы видеть новые сообщения об ошибках по мере их появления:

Bash

journalctl -f -p err
-f (или --follow): Показывает последние сообщения и продолжает выводить новые по мере их поступления (аналогично tail -f). Нажмите Ctrl+C, чтобы остановить.
Комбинирование фильтров
Вы можете комбинировать флаги для более точного поиска:

Bash

# Ошибки ядра для службы NetworkManager за последнюю загрузку
journalctl -b -k -u NetworkManager.service -p err
2. Другие возможные места логов
Хотя journald является основным местом, некоторые старые приложения или специфические конфигурации могут все еще писать логи в традиционные файлы в каталоге /var/log/.

Логи Xorg (графический сервер): Если у вас проблемы с графикой, проверьте:
/var/log/Xorg.0.log (обычно для текущей сессии)
~/.local/share/xorg/Xorg.0.log (альтернативное расположение)
Логи специфичных приложений: Некоторые серверные приложения (например, веб-серверы nginx, apache, базы данных postgresql, mariadb) могут иметь свои собственные файлы логов ошибок, часто в подкаталогах /var/log/, например:
/var/log/nginx/error.log
/var/log/httpd/error_log (для Apache httpd)
3. Советы
Начните с малого: Сначала ищите ошибки за текущую загрузку (journalctl -b -p err). Если ничего нет, расширяйте временной диапазон или смотрите предыдущие загрузки.
Используйте grep: Если вывод journalctl слишком большой, вы можете использовать grep для поиска по ключевым словам (хотя journalctl имеет мощные встроенные фильтры):
Bash

journalctl -b -p err | grep -i 'failed'
Права доступа: Для просмотра всех системных логов может потребоваться sudo или права root. journalctl без sudo часто показывает только логи текущего пользователя.
Bash

sudo journalctl -b -p err
Arch Wiki: Не забывайте про Arch Wiki, это отличный ресурс для получения более подробной информации о journalctl и логировании в Arch Linux.




Чтобы удалить повторяющиеся строки из вывода `journalctl`, можно использовать команду `uniq`. Вот несколько способов с использованием стандартных Unix-утилит:

1. **Базовый вариант с `uniq`**:
   ```bash
   sudo journalctl -b -p 3 | uniq
   ```
   Команда `uniq` удаляет только соседние повторяющиеся строки, поэтому перед использованием убедитесь, что вывод отсортирован (если порядок строк не важен).

2. **Сортировка и удаление дубликатов**:
   Если повторяющиеся строки не находятся рядом, используйте `sort` вместе с `uniq`:
   ```bash
   sudo journalctl -b -p 3 | sort | uniq
   ```
   Команда `sort` сортирует строки, а `uniq` удаляет дубликаты.

3. **Игнорирование временных меток**:
   Если вы хотите считать строки одинаковыми, игнорируя временные метки, можно обрезать их с помощью `cut` или `sed`:
   ```bash
   sudo journalctl -b -p 3 | cut -d ' ' -f 5- | sort | uniq
   ```
   Здесь `cut -d ' ' -f 5-` удаляет первые 4 поля (включая временную метку и хост), оставляя только сообщение.

4. **Сохранение результата в файл**:
   Если нужно сохранить результат:
   ```bash
   sudo journalctl -b -p 3 | sort | uniq > output.log
   ```

**Пример результата** для вашего вывода (с `sort | uniq`):
```
апр 27 21:45:10 admin-osiris kernel: cros-ec-keyb GOOG0007:00: cannot register non-matrix inputs: -74
апр 27 21:45:10 admin-osiris kernel: cros-ec-keyb GOOG0007:00: probe with driver cros-ec-keyb failed with error -74
апр 27 21:45:10 admin-osiris kernel: cros_ec_lpcs GOOG0004:00: Cannot identify the EC: error -95
апр 27 21:45:10 admin-osiris kernel: cros_ec_lpcs GOOG0004:00: EC responded to v2 hello with error: 1
апр 27 21:45:10 admin-osiris kernel: cros_ec_lpcs GOOG0004:00: couldn't register ec_dev (-95)
апр 27 21:45:10 admin-osiris kernel: cros_ec_lpcs GOOG0004:00: probe with driver cros_ec_lpcs failed with error -95
апр 27 21:45:11 admin-osiris kernel: Bluetooth: hci0: No support for _PRR ACPI method
апр 27 21:45:11 admin-osiris kernel: cros-ec-typec GOOG0014:00: couldn't find parent EC device
апр 27 21:45:15 admin-osiris kernel: HDMI2: ASoC: error at __soc_pcm_hw_params on HDMI2: -5
апр 27 21:45:15 admin-osiris kernel: HDMI2: ASoC: error at dpcm_fe_dai_hw_params on HDMI2: -5
апр 27 21:45:15 admin-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ASoC: error at snd_soc_pcm_component_hw_params o>
апр 27 21:45:15 admin-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: HW params ipc failed for stream 1
апр 27 21:45:15 admin-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ipc tx error for 0x60010000 (msg/reply size: 108>
```

Выберите вариант в зависимости от того, хотите ли вы сохранить временные метки или игнорировать их при сравнении строк.
