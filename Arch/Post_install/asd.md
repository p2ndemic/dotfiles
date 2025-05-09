
---

**1. Необходимые драйверы (✓)**

(Драйверы, критичные для функциональности *И/ИЛИ* фактически загруженные в системе)

| Модуль                   | Назначение                                                         | Необходимость |
| :----------------------- | :----------------------------------------------------------------- | :-----------: |
| `chromeos_acpi`          | Поддержка специфичных для ChromeOS расширений ACPI                 |       ✓       |
| `cros_charge-control`    | Управление параметрами зарядки батареи через EC                    |       ✓       |
| `cros_ec`                | **Ядро (core) фреймворка** для работы с EC                         |       ✓       |
| `cros_ec_chardev`        | Интерфейс `/dev/cros_ec` для userspace _[загружен]_                |       ✓       |
| `cros_ec_debugfs`        | Отладочный интерфейс через debugfs _[загружен]_                    |       ✓       |
| `cros_ec_dev`            | **Ключевой MFD драйвер:** создает дочерние устройства _[загружен]_ |       ✓       |
| `cros_ec_hwmon`          | Мониторинг температуры/вентиляторов через EC _[загружен]_          |       ✓       |
| `cros_ec_keyb`           | Драйвер встроенной клавиатуры через EC _[загружен]_                |       ✓       |
| `cros_ec_lpcs`           | **Транспорт:** Связь с EC по шине **LPC** _[загружен]_             |       ✓       |
| `cros_ec_sysfs`          | Интерфейс sysfs для информации от EC _[загружен]_                  |       ✓       |
| `cros-ec-typec`          | **Управление USB Type-C** через EC _[загружен]_                    |       ✓       |
| `cros_kbd_led_backlight` | Управление **подсветкой клавиатуры** через EC _[загружен]_         |       ✓       |
| `cros_typec_switch`      | Управление **переключателями/ретаймерами** Type-C через EC         |       ~       |
| `cros_usbpd-charger`     | Информация о зарядном устройстве USB PD _[загружен]_               |       ✓       |
| `cros_usbpd_logger`      | Логирование событий USB PD (отладка) _[загружен]_                  |       ✓       |
| `cros_usbpd_notify`      | Уведомления о событиях USB PD _[загружен]_                         |       ✓       |
| `cros_ec_ucsi`           | |               |
| `extcon-usbc-cros-ec`    | **Мост м/у EC и Extcon** для событий/свойств USB-C портов          |       ~       |
| `gpio-cros-ec`           | Доступ к GPIO, управляемым EC (напр., датчик крышки) _[загружен]_  |       ✓       |
| `leds-cros_ec`           | Упр. светодиодами статуса (питание, батарея) через EC _[загружен]_ |       ✓       |
| `pwm-cros-ec`            | Управление PWM через EC (подстветка клавиатуры/дисплея)            |       ~       |
| `snd-soc-cros-ec-codec`  | **ALSA SoC:** Управл. DMIC gain / I2S RX / WoV через EC            |       ~       |

**2. Опциональные / Ненужные драйверы (~ или пусто)**

| Модуль                   | Назначение                                                         | Необходимость |
| :------------------------| :----------------------------------------------------------------- | :-----------: |
| `chromeos_laptop`        | |       ~       |
| `chromeos_privacy_screen`| Управление экраном приватности                                     |               |
| `chromeos_pstore`        | Сохранение логов ядра между перезагрузками (отладка)               |               |
| `chromeos_tbmc`          | Контроллер режима планшета                                         |               |
| `cros_ec_accel_legacy`   | Драйвер для старых акселерометров через EC                         |               |
| `cros_ec_baro`           | Барометр через EC (IIO)                                            |               |
| `cros-ec-cec`            | Управление HDMI CEC через EC                                       |               |
| `cros_ec_sensors`        | Module to handle 3d contiguous sensors like Accelerometers, Gyroscope and Magnetometer (IIO) |               |
| `cros_ec_sensors_core`   | Ядро фреймворка для сенсоров EC (IIO)                              |               |
| `cros_ec_i2c`            | Связь с EC по шине I2C (не используется)                           |               |
| `cros_ec_ishtp`          | Связь с EC через Intel ISH (не используется)                       |               |
| `cros_ec_lid_angle`      | Датчик угла открытия крышки через EC (IIO)                         |               |
| `cros_ec_light_prox`     | Датчик освещенности/приближения через EC (IIO)                     |               |
| `cros_ec_lightbar`       | Управление световой панелью (старые Pixel)                         |               |
| `cros_ec_mkbp_proximity` | Специфический датчик приближения через EC (IIO)                    |               |
| `cros-ec-sensorhub`      | Мост для сенсоров EC в подсистему IIO                              |               |
| `cros_ec_spi`            | Связь с EC по шине SPI (не используется)                           |               |
| `cros_ec_uart`           | Связь с EC по UART (не используется)                               |               |
| `cros_ec_wdt`            | Сторожевой таймер (watchdog) через EC                              |       ~       |
| `cros_hps_i2c`           | Датчик присутствия человека                                        |               |
| `cros_peripheral_charger`| Зарядка периферии (стилус, клавиатура)                             |               |
| `i2c-cros-ec-tunnel`     | Доступ к I2C устройствам через "туннель" в EC                      |       ~       |
| `rtc-cros-ec`            | Часы реального времени (RTC) через EC                              |               |

---
