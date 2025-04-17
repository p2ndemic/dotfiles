# Добавить модули Chromebook чтобы исправить ошибку kernel: cros_ec_lpcs GOOG0004:00: packet too long (1 bytes, expected 0)
# https://github.com/torvalds/linux/tree/master/drivers/platform/chrome
#
# Проверить какие модули загружены:
# lsmod | grep -iE 'cros|chrome'
# zcat /proc/config.gz | grep -iE 'cros|chrome'
# find /lib/modules/$(uname -r) -path '*platform/chrome*' -name '*.ko*'
#
# Загрузить следующие модули:
# chromeos_acpi chromeos_laptop cros_ec cros_ec_lpc cros_ec_lpc_mec cros_ec_proto cros_ec_typec
MODULES=(chromeos_acpi chromeos_laptop cros_ec cros_ec_lpc cros_ec_lpc_mec cros_ec_proto cros_ec_typec)
