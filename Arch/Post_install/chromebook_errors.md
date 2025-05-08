https://thesofproject.github.io/latest/getting_started/intel_debug/introduction.html  
https://wiki.archlinux.org/title/Kernel_module  

---  
  
Ох и намучался я с этой ошибкой 🫩.  
Столько времени ушло на поиски и примерного решения этой проблемы 😮‍💨. Есть примерный вариант исправления, но я еще не проверял его в деле.  
  
В общем, после замены ненавистного ChromeOS на прошивку от любезного Mr. Chromebox и установки дистрибутива на базе Arch Linux, я столкнулся со следующими проблемами:

`sudo journalctl -b -p 3 | sort | uniq`:  
```bash
❯ journalctl -b -p 3 | sort | uniq
мая 08 21:42:09 google-osiris kernel: Bluetooth: hci0: No support for _PRR ACPI method
мая 08 21:42:09 google-osiris kernel: cros-ec-keyb GOOG0007:00: cannot register non-matrix inputs: -22
мая 08 21:42:09 google-osiris kernel: cros-ec-keyb GOOG0007:00: probe with driver cros-ec-keyb failed with error -22
мая 08 21:42:09 google-osiris kernel: cros_ec_lpcs GOOG0004:00: failed to retrieve wake mask: -22
мая 08 21:42:09 google-osiris kernel: cros-ec-typec GOOG0014:00: failed to get PD command version info
мая 08 21:42:09 google-osiris kernel: cros-ec-typec GOOG0014:00: probe with driver cros-ec-typec failed with error -22
мая 08 21:42:11 google-osiris bluetoothd[658]: Failed to set mode: Failed (0x03)
мая 08 21:42:13 google-osiris kernel:  Bluetooth: ASoC: error at dpcm_fe_dai_hw_params on Bluetooth: -22
мая 08 21:42:13 google-osiris kernel:  Bluetooth: ASoC: error at __soc_pcm_hw_params on Bluetooth: -22
мая 08 21:42:13 google-osiris kernel:  DMIC16kHz: ASoC: error at dpcm_fe_dai_hw_params on DMIC16kHz: -22
мая 08 21:42:13 google-osiris kernel:  DMIC16kHz: ASoC: error at __soc_pcm_hw_params on DMIC16kHz: -22
мая 08 21:42:13 google-osiris kernel:  HDMI2: ASoC: error at dpcm_fe_dai_hw_params on HDMI2: -5
мая 08 21:42:13 google-osiris kernel:  HDMI2: ASoC: error at __soc_pcm_hw_params on HDMI2: -5
мая 08 21:42:13 google-osiris kernel:  HDMI3: ASoC: error at dpcm_fe_dai_hw_params on HDMI3: -5
мая 08 21:42:13 google-osiris kernel:  HDMI3: ASoC: error at __soc_pcm_hw_params on HDMI3: -5
мая 08 21:42:13 google-osiris kernel:  HDMI4: ASoC: error at dpcm_fe_dai_hw_params on HDMI4: -5
мая 08 21:42:13 google-osiris kernel:  HDMI4: ASoC: error at __soc_pcm_hw_params on HDMI4: -5
мая 08 21:42:13 google-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ASoC: error at snd_soc_pcm_component_hw_params on 0000:00:1f.3: -22
мая 08 21:42:13 google-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ASoC: error at snd_soc_pcm_component_hw_params on 0000:00:1f.3: -5
мая 08 21:42:13 google-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: HW params ipc failed for stream 1
мая 08 21:42:13 google-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ipc tx error for 0x60010000 (msg/reply size: 108/20): -22
мая 08 21:42:13 google-osiris kernel: sof-audio-pci-intel-tgl 0000:00:1f.3: ipc tx error for 0x60010000 (msg/reply size: 108/20): -5
мая 08 21:42:14 google-osiris bluetoothd[658]: Failed to set mode: Failed (0x03)
мая 08 21:42:15 google-osiris bluetoothd[658]: Failed to set mode: Failed (0x03)
~
```

---

**1. Ошибки, связанные с ChromeOS Embedded Controller (EC):**

* `cros-ec-keyb GOOG0007:00: cannot register non-matrix inputs: -22`
* `cros-ec-keyb GOOG0007:00: probe with driver cros-ec-keyb failed with error -22`
* `cros_ec_lpcs GOOG0004:00: failed to retrieve wake mask: -22`
* `cros-ec-typec GOOG0014:00: failed to get PD command version info`
* `cros-ec-typec GOOG0014:00: probe with driver cros-ec-typec failed with error -22`
  
**Описание:**  
- Эти ошибки указывают на проблемы с инициализацией драйверов, отвечающих за взаимодействие со встроенным контроллером ChromeOS Embedded Controller (`cros-ec`).  
Этот контроллер реализуется через нижестоящую транспортную шину LPC (драйвер `cros_ec_lpcs`), управляет ACPI, режимами сна/пробуждения, портами Type-C, USBPD, клавиатурой (особенно функциональными клавишами) и другими низкоуровневыми функциями.  
  
- Код ошибки `-22` обычно означает `EINVAL` (Invalid argument). Вероятно, драйверы ядра Linux получают от EC или через ACPI данные, которые они не ожидают или не поддерживают для данной конкретной модели Chromebook (Google Osiris). Это может приводить к множествам проблем в работе систем ACPI, TypeC, USBPD (power delivery) и др.

**Результат:**  
Эта ошибка критична т.к она приводит к некорректной работе ACPI, TypeC, Power Delivery через USB TypeC, KEYB и т.д.  
1. Из-за нее пропала возможность устанавливать пороги заряда через параметр `charge_control_end_threshold` (файл отсутствует в директрии `/sys/class/power_supply/`).  
Параметр также недоступен в KDE: "_Параметры системы_" -> "_Управление питанием_" -> "_Дополнительные параметры управления питанием_" (см. скриншот).  
2. Верхний функциональный и цифровой ряд клавиатуры дает сбой и не работает время от времени. Приходится перезагружаться, чтобы драйвер `cros_ec_keyb` смог правильно инициализироваться.  

```bash
❯ cat /sys/class/power_supply/BAT0/charge_control_end_threshold
cat: /sys/class/power_supply/BAT0/charge_control_end_threshold: Нет такого файла или каталога
```
```bash
❯ ls -l /sys/class/power_supply/BAT0/
lrwxrwxrwx    - root  8 мая 21:48  device -> ../../../PNP0C0A:00
drwxr-xr-x    - root  8 мая 21:48  extensions
drwxr-xr-x    - root  8 мая 21:48  hwmon2
drwxr-xr-x    - root  8 мая 21:48  power
lrwxrwxrwx    - root  8 мая 21:48  subsystem -> ../../../../../../../../../class/power_supply
.rw-r--r-- 4,1k root  8 мая 21:48  alarm
.r--r--r-- 4,1k root  8 мая 21:48  capacity
.r--r--r-- 4,1k root  8 мая 21:48  capacity_level
.r--r--r-- 4,1k root  8 мая 21:48  charge_full
.r--r--r-- 4,1k root  8 мая 21:48  charge_full_design
.r--r--r-- 4,1k root  8 мая 21:48  charge_now
.r--r--r-- 4,1k root  8 мая 21:48  current_now
.r--r--r-- 4,1k root  8 мая 21:48  cycle_count
.r--r--r-- 4,1k root  8 мая 21:48  manufacturer
.r--r--r-- 4,1k root  8 мая 21:48  model_name
.r--r--r-- 4,1k root  8 мая 21:48  present
.r--r--r-- 4,1k root  8 мая 21:48  serial_number
.r--r--r-- 4,1k root  8 мая 21:48  status
.r--r--r-- 4,1k root  8 мая 21:48  technology
.r--r--r-- 4,1k root  8 мая 21:48  type
.rw-r--r-- 4,1k root  8 мая 21:48  uevent
.r--r--r-- 4,1k root  8 мая 21:48  voltage_min_design
.r--r--r-- 4,1k root  8 мая 21:48  voltage_now
~
❯
```
<img src="https://github.com/user-attachments/assets/c85a743f-f623-4ff0-9b7e-2ff928335223" width=50% height=50%>

---

**2. Ошибки Bluetooth:**

* `Bluetooth: hci0: No support for _PRR ACPI method`  
* `Bluetooth: ASoC: error at dpcm_fe_dai_hw_params on Bluetooth: -22`  
* `Bluetooth: ASoC: error at __soc_pcm_hw_params on Bluetooth: -22`

**Описание:**  
- Первая ошибка (`_PRR ACPI method`) указывает на отсутствие поддержки специфического метода управления питанием Bluetooth через ACPI. Это может быть некритично, но потенциально может влиять на энергопотребление Bluetooth.  
  
- Остальные ошибки Bluetooth связаны с аудиоподсистемой ALSA (ASoC - ALSA System on Chip) и указывают на проблемы при настройке параметров аудиопотока для Bluetooth. Опять же, ошибка `-22` (`EINVAL`). Это может мешать работе Bluetooth-аудиоустройств (наушников, колонок).

**Результат:**  
Эта ошибка не сильно критична, важнее исправить ошибки #1 и #3. И после, заняться исправлением данной.

---

**3. Ошибки Аудио (SOF | ASoC):**

* `sof-audio-pci-intel-tgl 0000:00:1f.3: ASoC: error at snd_soc_pcm_component_hw_params on 0000:00:1f.3: -22`  
* `sof-audio-pci-intel-tgl 0000:00:1f.3: ASoC: error at snd_soc_pcm_component_hw_params on 0000:00:1f.3: -5`  
* `sof-audio-pci-intel-tgl 0000:00:1f.3: HW params ipc failed for stream 1`  
* `sof-audio-pci-intel-tgl 0000:00:1f.3: ipc tx error for 0x60010000 (msg/reply size: 108/20): -22`  
* `sof-audio-pci-intel-tgl 0000:00:1f.3: ipc tx error for 0x60010000 (msg/reply size: 108/20): -5`  
  
- `DMIC16kHz: ASoC: error at dpcm_fe_dai_hw_params on DMIC16kHz: -22`  
- `DMIC16kHz: ASoC: error at __soc_pcm_hw_params on DMIC16kHz: -22`  
- `HDMIx: ASoC: error at dpcm_fe_dai_hw_params on HDMI2: -5`  
  
**Описание:**  
- Это самая многочисленная группа ошибок, и все они связаны с аудиоподсистемой `sof-audio-pci-intel-tgl`, которая используется на современных платформах Intel (включая Alder Lake-P). SOF (Sound Open Firmware) - это прошивка и драйверы для обработки звука на DSP (цифровом сигнальном процессоре).  
  
- Ошибки указывают на проблемы с настройкой параметров (`hw_params`) для различных аудиоинтерфейсов: цифрового микрофона (`DMIC`), HDMI-аудиовыходов и основного аудиоустройства PCI.  
  
- Коды ошибок `-22` (`EINVAL`) и `-5` (`EIO` - Input/Output error - Ошибка ввода/вывода) говорят о проблемах с передачей корректных параметров оборудованию или об ошибках связи (IPC - Inter-Process Communication) с прошивкой SOF на DSP.  
  
**Результат:**  
После загрузки системы не работает звук. При нажатии на значок громкости в KDE, система сообщает что `'Не найдено устройств ввода или
вывода звука'` (см. скриншот):  

<img src="https://github.com/user-attachments/assets/a321909a-7741-44ba-ae3f-c68d9d44447b" width=25% height=25%>

---

Ок, первое что нужно исправить, это ошибки `#1` и `#3`. Ошибка `#2` не является критичной и косвенно зависит от `#1` и `#3`, поэтому после анализа первопричин ошибок с последующим их исправлением, проблема должна быть решенена и для этой части.  
Еще раз напомню что я не являюсь программистом, более того

Первое что нужно сделать, это проверить логи ошибки ядра через `journalctl` и загруженные модули звуковых драйверов через `lsmod | grep -iE 'snd'`:  
  
`lsmod | grep -iE 'snd'`  
```bash
[admin@admin-osiris ~]$ lsmod | grep -iE 'snd'
snd_seq_dummy          12288  0
snd_hrtimer            12288  1
snd_seq               131072  7 snd_seq_dummy
snd_seq_device         16384  1 snd_seq
snd_soc_sof_nau8825    20480  1
snd_soc_intel_sof_nuvoton_common    12288  1 snd_soc_sof_nau8825
snd_soc_intel_sof_realtek_common    32768  1 snd_soc_sof_nau8825
snd_soc_intel_sof_board_helpers    28672  1 snd_soc_sof_nau8825
snd_soc_intel_hda_dsp_common    16384  1 snd_soc_intel_sof_board_helpers
snd_sof_probes         28672  0
snd_soc_intel_sof_maxim_common    32768  1 snd_soc_sof_nau8825
snd_soc_dmic           12288  1
snd_sof_pci_intel_tgl    16384  0
snd_sof_pci_intel_cnl    20480  1 snd_sof_pci_intel_tgl
snd_sof_intel_hda_generic    45056  2 snd_sof_pci_intel_tgl,snd_sof_pci_intel_cnl
soundwire_intel        86016  1 snd_sof_intel_hda_generic
snd_sof_intel_hda_common   208896  3 snd_sof_intel_hda_generic,snd_sof_pci_intel_tgl,snd_sof_pci_intel_cnl
snd_soc_hdac_hda       28672  1 snd_sof_intel_hda_common
snd_sof_intel_hda_mlink    36864  3 soundwire_intel,snd_sof_intel_hda_common,snd_sof_intel_hda_generic
snd_sof_intel_hda      20480  2 snd_sof_intel_hda_common,snd_sof_intel_hda_generic
snd_hda_codec_hdmi     98304  1
snd_sof_pci            24576  3 snd_sof_intel_hda_generic,snd_sof_pci_intel_tgl,snd_sof_pci_intel_cnl
snd_sof_xtensa_dsp     16384  1 snd_sof_intel_hda_generic
snd_sof               466944  9 snd_soc_sof_nau8825,snd_sof_pci,snd_sof_intel_hda_common,snd_soc_intel_sof_realtek_common,snd_sof_intel_hda_generic,snd_soc_intel_sof_maxim_common,snd_sof_probes,snd_sof_intel_hda,snd_sof_pci_intel_cnl
snd_sof_utils          16384  1 snd_sof
snd_soc_acpi_intel_match   131072  4 snd_soc_intel_sof_board_helpers,snd_sof_intel_hda_generic,snd_sof_pci_intel_tgl,snd_sof_pci_intel_cnl
snd_soc_acpi_intel_sdca_quirks    12288  1 snd_soc_acpi_intel_match
snd_soc_acpi           16384  2 snd_soc_acpi_intel_match,snd_sof_intel_hda_generic
snd_soc_sdca           12288  2 snd_soc_acpi_intel_sdca_quirks,soundwire_bus
snd_soc_avs           241664  0
snd_soc_hda_codec      28672  1 snd_soc_avs
snd_hda_ext_core       36864  6 snd_soc_avs,snd_soc_hda_codec,snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_sof_intel_hda_mlink,snd_sof_intel_hda
snd_hda_intel          69632  0
snd_soc_max98357a      16384  1
snd_soc_nau8825        73728  1
snd_intel_dspcfg       40960  5 snd_soc_avs,snd_hda_intel,snd_sof,snd_sof_intel_hda_common,snd_sof_intel_hda_generic
snd_intel_sdw_acpi     16384  2 snd_intel_dspcfg,snd_sof_intel_hda_generic
snd_soc_core          450560  15 snd_soc_avs,snd_soc_hda_codec,snd_soc_sof_nau8825,snd_soc_intel_sof_nuvoton_common,soundwire_intel,snd_sof,snd_soc_intel_sof_board_helpers,snd_sof_intel_hda_common,snd_soc_intel_sof_realtek_common,snd_soc_hdac_hda,snd_soc_intel_sof_maxim_common,snd_soc_max98357a,snd_sof_probes,snd_soc_dmic,snd_soc_nau8825
snd_hda_codec         212992  7 snd_soc_avs,snd_hda_codec_hdmi,snd_soc_hda_codec,snd_hda_intel,snd_soc_intel_hda_dsp_common,snd_soc_hdac_hda,snd_sof_intel_hda
snd_compress           28672  3 snd_soc_avs,snd_soc_core,snd_sof_probes
snd_hda_core          147456  10 snd_soc_avs,snd_hda_codec_hdmi,snd_soc_hda_codec,snd_hda_intel,snd_hda_ext_core,snd_hda_codec,snd_soc_intel_hda_dsp_common,snd_sof_intel_hda_common,snd_soc_hdac_hda,snd_sof_intel_hda
ac97_bus               12288  1 snd_soc_core
snd_pcm_dmaengine      16384  1 snd_soc_core
snd_hwdep              20480  1 snd_hda_codec
snd_pcm               200704  16 snd_soc_avs,snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,soundwire_intel,snd_sof,snd_sof_intel_hda_common,snd_compress,snd_soc_intel_sof_realtek_common,snd_sof_intel_hda_generic,snd_soc_core,snd_sof_utils,snd_soc_intel_sof_maxim_common,snd_hda_core,snd_soc_nau8825,snd_pcm_dmaengine
snd_timer              57344  3 snd_seq,snd_hrtimer,snd_pcm
snd                   155648  16 snd_seq,snd_seq_device,snd_hda_codec_hdmi,snd_hwdep,snd_soc_sof_nau8825,snd_hda_intel,snd_hda_codec,snd_sof,snd_timer,snd_compress,snd_soc_core,snd_pcm
soundcore              16384  1 snd
[admin@admin-osiris ~]$
```

---

Тут мы видим:  
1. Множество ошибок связанных с `sof-audio-pci-intel-tgl` в `journalctl`. Это и есть причина проблемы.  
2. Множество загруженных модулей аудиодрайверов. Нас интересуют два их них - `snd_soc_sof_nau8825` и `snd_sof_pci_intel_tgl`. Остальные будем добавлять в блеклист и тестить.  
В общем будем дальше искать rootcause ...  

---
  
Первое что нужно сделать - определить технические характеристики текущего устройства. Тут помогут CLI утилиты ```inxi``` и  ```pactl```, а также ```wpctl``` (опционально).

Примеры использования ***inxi***:  
  ```inxi -Fxz``` - вывести всю необходимую информацию о системе/устройстве  
  ```inxi -Aa``` - вывести информацию о аудиоустройстве/аудиокодеках  
  
Пример использования ***pactl***:  
  ```pactl list cards``` - вывести полную информацию о аудиокарте

---
Запустим эти две утилиты и проверим информацию:

```
[admin@admin-osiris ~]$ inxi -aA
Audio:
  Device-1: Intel Alder Lake PCH-P High Definition Audio
    driver: sof-audio-pci-intel-tgl alternate: snd_hda_intel, snd_soc_avs,
    snd_sof_pci_intel_tgl bus-ID: 00:1f.3 chip-ID: 8086:51c8 class-ID: 0401
  API: ALSA v: k6.14.4-arch1-1 status: kernel-api
    tools: alsactl,alsamixer,amixer
  Server-1: PipeWire v: 1.4.2 status: active with: 1: pipewire-pulse
    status: active 2: wireplumber status: active 3: pipewire-alsa type: plugin
    4: pw-jack type: plugin tools: pactl,pw-cat,pw-cli,wpctl
```
```
[admin@admin-osiris ~]$ pactl list cards
Card #42
	Name: alsa_card.pci-0000_00_1f.3-platform-adl_nau8825_def
	Driver: alsa
	Owner Module: n/a
	Properties:
		api.acp.auto-port = "false"
		api.acp.auto-profile = "false"
		api.alsa.card = "0"
		api.alsa.card.longname = "Google-Osiris-rev3"
		api.alsa.card.name = "sof-nau8825"
		api.alsa.path = "hw:0"
		api.alsa.split-enable = "true"
		api.alsa.use-acp = "true"
		api.dbus.ReserveDevice1 = "Audio0"
		api.dbus.ReserveDevice1.Priority = "-20"
		device.api = "alsa"
		device.bus = "pci"
		device.bus_path = "pci-0000:00:1f.3-platform-adl_nau8825_def"
		device.description = "Alder Lake PCH-P High Definition Audio Controller"
		device.enum.api = "udev"
		device.icon_name = "audio-card-analog-pci"
		device.name = "alsa_card.pci-0000_00_1f.3-platform-adl_nau8825_def"
		device.nick = "sof-nau8825"
		device.plugged.usec = "4233721"
		device.product.id = "0x51c8"
		device.product.name = "Alder Lake PCH-P High Definition Audio Controller"
		device.subsystem = "sound"
		sysfs.path = "/devices/pci0000:00/0000:00:1f.3/adl_nau8825_def/sound/card0"
		device.vendor.id = "0x8086"
		device.vendor.name = "Intel Corporation"
		media.class = "Audio/Device"
		spa.object.id = "2"
		factory.id = "15"
		client.id = "41"
		object.id = "42"
		object.serial = "42"
		object.path = "alsa:acp:sofnau8825"
		alsa.card = "0"
		alsa.card_name = "sof-nau8825"
		alsa.long_card_name = "Google-Osiris-rev3"
		alsa.driver_name = "snd_soc_sof_nau8825"
		alsa.mixer_name = "Intel Alderlake-P HDMI"
		alsa.components = "HDA:8086281c,80860101,00100000"
		alsa.id = "sofnau8825"
		device.string = "0"
	Profiles:
		off: Выключено (sinks: 0, sources: 0, priority: 0, available: yes)
		output:stereo-fallback: Стерео выход (sinks: 1, sources: 0, priority: 5100, available: no)
		pro-audio: Pro Audio (sinks: 7, sources: 5, priority: 1, available: yes)
	Active Profile: off
	Ports:
		analog-output-headphones: Наушники (type: Headphones, priority: 9900, latency offset: 0 usec, availability group: Legacy 1, not available)
			Properties:
				port.type = "headphones"
				port.availability-group = "Legacy 1"
				device.icon_name = "audio-headphones"
				card.profile.port = "0"
			Part of profile(s): output:stereo-fallback
[admin@admin-osiris ~]$
```
---
Тут мы видим следующую инфомацию:
1. Device-1: Intel Alder Lake PCH-P High Definition Audio  
   driver: sof-audio-pci-intel-tgl alternate: snd_hda_intel, snd_soc_avs
2. device.product.name = "Alder Lake PCH-P High Definition Audio Controller
   alsa.driver_name = "snd_soc_sof_nau8825"
   sysfs.path = "/devices/pci0000:00/0000:00:1f.3/adl_nau8825_def/sound/card0"
Ок, с этими данными будем работать.


Далее, гуглим и изучаем маны/гайды SOF. Находим вот вот эту статью: https://thesofproject.github.io/latest/getting_started/intel_debug/introduction.html

#### Краткий анализ документации:  
  
---
  
#### **1. Конфликты драйверов и настройка через `snd-intel-dspcfg`**
- **Проблема**:  
  До 2020 года разные драйверы (например, `snd-hda-intel`, `snd-sof`, `snd-soc-skl`) могли регистрироваться на одно и то же PCI ID, что приводило к конфликтам. Решение требовало ручного редактирования конфигурации ядра (`/etc/modprobe.d/`) или исключения драйверов, что было неудобно для пользователей и дистрибутивов.

- **Решение**:  
  В 2020 году появился модуль **`snd-intel-dspcfg`**, который:
  - Унифицирует API для всех драйверов.
  - Позволяет переопределить выбор драйвера через параметр **`dsp_driver`**:
    - **`dsp_driver=1`** — принудительно использовать legacy-драйвер `snd-hda-intel`. Подходит для базовых аудиоустройств (динамики, наушники), но **не поддерживает цифровые микрофоны (DMIC)**.
    - **`dsp_driver=3`** — принудительно использовать современный драйвер **SOF** (Sound Open Firmware), даже если DSP не требуется. Это полезно, если OEM включил DSP, но система не рассчитана на его использование.

  Пример настройки в `/etc/modprobe.d/`:  
  ```bash
  options snd-intel-dspcfg dsp_driver=1  # или 3
  ```
  
---
  
#### **2. Требования к файловой системе и прошивке**  
Для корректной работы SOF необходимы три компонента:  
  
1. **Прошивка DSP**:  
  
| Platform                                 | IPC type | Load path                                    |
| ---------------------------------------- | -------- | -------------------------------------------- |
| Raptor Lake and older                    | IPC3     | /lib/firmware/intel/sof/                     |
| Raptor Lake and older (community signed) | IPC3     | /lib/firmware/intel/sof/community/           |
| Tiger Lake and newer                     | IPC4     | /lib/firmware/intel/sof-ipc4/PLAT/           |
| iger Lake and newer (community signed)   | IPC4     | /lib/firmware/intel/sof-ipc4/PLAT/community/ |
  
   - Подпись: 
     - Обычно требуется подпись Intel (для потребительских устройств).
     - **Исключения**:  
       $\color{Red}\large{\textbf{Chromebooks}}$ и Up2/Up-Extreme платы используют **community key**, что позволяет устанавливать кастомную прошивку.
   - **Проблема с Intel ME**:  
     Management Engine (ME) проверяет подпись прошивки. Если ME отключен в BIOS, загрузка прошивки **SOF** ***невозможна***. Решение — переключиться на `snd-hda-intel` или включить ME.
   - Может быть переопределен через параметры ядра: `snd_sof` `fw_path` и `fw_filename`
     - Пример:  
       `sudo nano /etc/modprobe.d/sof.conf`
       ```bash
       options snd_sof fw_path="/lib/firmware/intel/sof-ipc4/adl/community/" fw_filename="sof-adl.ri"
       ```  
  
2. **Топологический файл**:
   - Описывает структуру аудиокомпонентов (кодеки, PCM-устройства).
   - Пути:  
     - **IPC3**: `/lib/firmware/intel/sof-tplg/`.
     - **IPC4**: `/lib/firmware/intel/sof-ipc4-tplg/`.
   - Может быть переопределен через параметры ядра: `snd_sof` `tplg_path` и `tplg_filename`.
     - Пример:  
       `sudo nano /etc/modprobe.d/sof.conf`
       ```bash
       options snd_sof tplg_path="/lib/firmware/intel/sof-tplg/" tplg_filename="sof-adl-nau8825.tplg"
       ```  
  
3. **UCM-файлы**:
   - Конфигурируют управление аудиоустройствами (например, громкость, переключение между динамиками и наушниками).
   - Расположение: `/usr/share/alsa/ucm2/`.
   - Совместимы с разными драйверами, включая `snd-hda-intel` и SOF.

---

```c++
#if IS_ENABLED(CONFIG_SND_SOC_SOF_TIGERLAKE)
static const struct sof_dev_desc tgl_desc = {
	.machines               = snd_soc_acpi_intel_tgl_machines,
	.alt_machines		= snd_soc_acpi_intel_tgl_sdw_machines,
	.use_acpi_target_states	= true,
	.resindex_lpe_base      = 0,
	.resindex_pcicfg_base   = -1,
	.resindex_imr_base      = -1,
	.irqindex_host_ipc      = -1,
	.resindex_dma_base      = -1,
	.chip_info = &tgl_chip_info,
	.default_fw_path = "intel/sof",
	.default_tplg_path = "intel/sof-tplg",
	.default_fw_filename = "sof-tgl.ri",
	.nocodec_tplg_filename = "sof-tgl-nocodec.tplg",
	.ops = &sof_tgl_ops,
};
```
