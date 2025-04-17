#### Chromebook drivers
#### https://github.com/torvalds/linux/tree/master/drivers/platform/chrome


Привет! Понимаю ваше беспокойство по поводу кастомного ядра. CachyOS действительно оптимизирует свои ядра, и иногда это может включать отключение драйверов, которые считаются ненужными для большинства пользователей. Драйверы из `drivers/platform/chrome/` специфичны для устройств ChromeOS и их встроенных контроллеров (EC). Если ваше оборудование не является Chromebook или не использует компоненты, требующие этих специфических драйверов, то их отсутствие, скорее всего, не повлияет на работу системы.

Вот несколько способов проверить, включены ли конкретные драйверы или функции ядра в вашем текущем ядре CachyOS:

1.  **Проверка через конфигурационный файл ядра (`/proc/config.gz` или в `/boot`)**

    Это самый надежный способ узнать, как было скомпилировано ядро. Многие дистрибутивы, включая Arch-подобные, предоставляют доступ к конфигурационному файлу работающего ядра.

    * **Если доступен `/proc/config.gz`:**
        Выполните команду в терминале:
        ```bash
        zcat /proc/config.gz | grep CONFIG_CHROME_PLATFORMS
        ```
        Или для более конкретных драйверов из этого каталога (имена опций можно найти в файле `Kconfig` в директории `drivers/platform/chrome/` исходников ядра):
        ```bash
        zcat /proc/config.gz | grep CONFIG_CROS_EC         # Общий драйвер EC
        zcat /proc/config.gz | grep CONFIG_CROS_EC_I2C      # EC через I2C
        zcat /proc/config.gz | grep CONFIG_CROS_EC_SPI      # EC через SPI
        zcat /proc/config.gz | grep CONFIG_CHROMEOS_LAPTOP  # Функции специфичные для лэптопов ChromeOS
        # и так далее для других CONFIG_ опций...
        ```
        * Если вывод показывает `=y`, значит, драйвер встроен прямо в ядро.
        * Если вывод показывает `=m`, значит, драйвер скомпилирован как загружаемый модуль.
        * Если строка закомментирована (`# CONFIG_... is not set`) или отсутствует, значит, драйвер/функция не включены в ядро.

    * **Если `/proc/config.gz` отсутствует:**
        Ядро могло быть скомпилировано без опции `CONFIG_IKCONFIG_PROC`. В этом случае конфигурационный файл часто можно найти в директории `/boot`:
        ```bash
        grep CONFIG_CHROME_PLATFORMS /boot/config-$(uname -r)
        # Или другие CONFIG_ опции, как в примере выше
        ```
        Замените `$(uname -r)` на точную версию вашего ядра CachyOS, если команда не сработает автоматически (узнать версию можно командой `uname -r`).

2.  **Проверка наличия модулей ядра**

    Если драйверы скомпилированы как модули (`=m`), их файлы (`.ko` или `.ko.zst` в случае сжатия) должны находиться в директории модулей вашего ядра.

    * Вы можете поискать модули, относящиеся к ChromeOS EC или платформе:
        ```bash
        find /lib/modules/$(uname -r) -type f -name '*cros*'
        ```
        Или более точно по пути:
        ```bash
        find /lib/modules/$(uname -r) -path '*platform/chrome*' -name '*.ko*'
        ```
        Наличие файлов, таких как `cros_ec_i2c.ko.zst`, `chromeos_laptop.ko.zst` и т.д., будет означать, что эти драйверы доступны как модули.

3.  **Проверка загруженных модулей**

    Этот метод покажет, какие модули *уже* загружены в память. Драйвер может существовать как модуль, но не быть загруженным, если соответствующее оборудование не обнаружено или не используется.
    ```bash
    lsmod | grep cros
    ```
    Если вы видите в списке модули типа `cros_ec_i2c`, `cros_ec_spi`, `chromeos_laptop` и т.п., значит они активны.

**Резюме:**

* Самый точный метод - проверить конфигурационный файл ядра (`/proc/config.gz` или `/boot/config-...`). Он покажет, встроен ли драйвер (`=y`), доступен как модуль (`=m`) или выключен.
* Поиск файлов `.ko*` в `/lib/modules/` покажет, какие драйверы доступны в виде модулей.
* `lsmod` покажет, какие из доступных модулей загружены в данный момент.

Учитывая специфику `drivers/platform/chrome/`, если у вас не Chromebook, то отсутствие этих драйверов в ядре CachyOS, скорее всего, является ожидаемым поведением и не должно вызывать проблем. Они нужны в основном для взаимодействия с Embedded Controller (EC) на ChromeOS-устройствах для управления питанием, клавиатурой, подсветкой и т.д.

----#######################################----
```bash
❯ zcat /proc/config.gz | grep CONFIG_CHROME_PLATFORMS
CONFIG_CHROME_PLATFORMS=y

~
❯ zcat /proc/config.gz | grep CONFIG_CROS_EC
CONFIG_CROS_EC_WATCHDOG=m
CONFIG_CROS_EC_UCSI=m
CONFIG_CROS_EC=m
CONFIG_CROS_EC_I2C=m
CONFIG_CROS_EC_ISHTP=m
CONFIG_CROS_EC_SPI=m
CONFIG_CROS_EC_UART=m
CONFIG_CROS_EC_LPC=m
CONFIG_CROS_EC_PROTO=y
CONFIG_CROS_EC_CHARDEV=m
CONFIG_CROS_EC_LIGHTBAR=m
CONFIG_CROS_EC_DEBUGFS=m
CONFIG_CROS_EC_SENSORHUB=m
CONFIG_CROS_EC_SYSFS=m
CONFIG_CROS_EC_TYPEC_ALTMODES=y
CONFIG_CROS_EC_TYPEC=m
CONFIG_CROS_EC_MKBP_PROXIMITY=m

~
❯ find /lib/modules/$(uname -r) -type f -name '*cros*'
/lib/modules/6.14.2-2-cachyos/kernel/drivers/extcon/extcon-usbc-cros-ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/gpio/gpio-cros-ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/hid/hid-microsoft.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/hwmon/cros_ec_hwmon.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/i2c/busses/i2c-cros-ec-tunnel.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/accel/cros_ec_accel_legacy.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/common/cros_ec_sensors/cros_ec_lid_angle.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/common/cros_ec_sensors/cros_ec_sensors.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/common/cros_ec_sensors/cros_ec_sensors_core.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/light/cros_ec_light_prox.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/pressure/cros_ec_baro.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/iio/proximity/cros_ec_mkbp_proximity.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/input/keyboard/cros_ec_keyb.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/leds/leds-cros_ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/media/cec/platform/cros-ec/cros-ec-cec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/mfd/cros_ec_dev.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros-ec-sensorhub.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros-ec-typec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_chardev.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_debugfs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_i2c.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_ishtp.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_lightbar.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_lpcs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_spi.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_sysfs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_uart.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_hps_i2c.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_kbd_led_backlight.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_typec_switch.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_usbpd_logger.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_usbpd_notify.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/power/supply/cros_charge-control.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/power/supply/cros_peripheral_charger.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/power/supply/cros_usbpd-charger.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/pwm/pwm-cros-ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/rtc/rtc-cros-ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/usb/typec/ucsi/cros_ec_ucsi.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/watchdog/cros_ec_wdt.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/sound/soc/codecs/snd-soc-cros-ec-codec.ko.zst
/lib/modules/6.14.2-2-cachyos/build/include/dt-bindings/input/cros-ec-keyboard.h
/lib/modules/6.14.2-2-cachyos/build/include/dt-bindings/mfd/cros_ec.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/iio/common/cros_ec_sensors_core.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/util_macros.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/platform_data/cros_ec_chardev.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/platform_data/cros_ec_commands.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/platform_data/cros_ec_proto.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/platform_data/cros_ec_sensorhub.h
/lib/modules/6.14.2-2-cachyos/build/include/linux/platform_data/cros_usbpd_notify.h

~
❯ find /lib/modules/$(uname -r) -path '*platform/chrome*' -name '*.ko*'
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/chromeos_acpi.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/chromeos_laptop.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/chromeos_privacy_screen.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/chromeos_pstore.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/chromeos_tbmc.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros-ec-sensorhub.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros-ec-typec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_chardev.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_debugfs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_i2c.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_ishtp.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_lightbar.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_lpcs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_spi.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_sysfs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_ec_uart.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_hps_i2c.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_kbd_led_backlight.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_typec_switch.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_usbpd_logger.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/cros_usbpd_notify.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/wilco_ec/wilco_ec.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/wilco_ec/wilco_ec_debugfs.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/wilco_ec/wilco_ec_events.ko.zst
/lib/modules/6.14.2-2-cachyos/kernel/drivers/platform/chrome/wilco_ec/wilco_ec_telem.ko.zst
```
