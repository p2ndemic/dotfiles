# Настройка UFW: Разрешение ICMP для PMTUD в Arch Linux

Эта инструкция описывает, как разрешить необходимые типы ICMP в UFW (Uncomplicated Firewall) для корректной работы механизма Path MTU Discovery (PMTUD) в Arch Linux. Это важно для стабильной работы сети, особенно при взаимодействии с хостами через маршрутизаторы с меньшим MTU.

Изменения вносятся в файлы `/etc/ufw/before.rules` (для IPv4) и `/etc/ufw/before6.rules` (для IPv6).

## Шаг 1: Редактирование правил IPv4 (`before.rules`)

1.  Откройте файл с правами суперпользователя:
    ```bash
    sudo nano /etc/ufw/before.rules
    ```

2.  Найдите в файле раздел правил для цепочки `ufw-before-input`. Обычно он содержит комментарии и уже существующие правила.

3.  Добавьте следующую строку **перед** любыми финальными правилами `DROP` или `REJECT` в этой цепочке (если их нет, добавьте в конец секции `ufw-before-input`, но *до* строки `COMMIT`):

    ```
    # Разрешаем ICMPv4 Destination Unreachable (необходимо для PMTUD и ошибок)
    -A ufw-before-input -p icmp --icmp-type destination-unreachable -j ACCEPT
    ```

4.  Сохраните файл (`Ctrl+O`, `Enter` в `nano`) и закройте редактор (`Ctrl+X`).

## Шаг 2: Редактирование правил IPv6 (`before6.rules`)

1.  Откройте файл с правами суперпользователя:
    ```bash
    sudo nano /etc/ufw/before6.rules
    ```

2.  Найдите в файле раздел правил для цепочки `ufw6-before-input`.

3.  Добавьте следующую строку **перед** любыми финальными правилами `DROP` или `REJECT` в этой цепочке (или до `COMMIT`, как в шаге 1):

    ```
    # Разрешаем ICMPv6 Packet Too Big (необходимо для PMTUD)
    -A ufw6-before-input -p ipv6-icmp --icmp-type packet-too-big -j ACCEPT
    ```

4.  Сохраните файл и закройте редактор.

## Шаг 3: Применение изменений

Чтобы новые правила вступили в силу, перезагрузите UFW:

```bash
sudo ufw reload
