4600523344136067214

find / -name "*waydroid*" 2> /dev/null

sudo rm -rf \
  /opt/waydroid-script \
  /sys/fs/cgroup/system.slice/waydroid-container.service \
  /var/cache/pacman/pkg/waydroid-image-18.1_20241116-2-x86_64.pkg.tar.zst.sig \
  /var/cache/pacman/pkg/waydroid-1.5.1-1-any.pkg.tar.zst \
  /var/cache/pacman/pkg/waydroid-image-18.1_20241116-2-x86_64.pkg.tar.zst \
  /var/cache/pacman/pkg/waydroid-1.5.1-1-any.pkg.tar.zst.sig \
  /var/lib/misc/dnsmasq.waydroid0.leases \
  /etc/waydroid-extra \
  /run/waydroid-lxc \
  /run/lxc/lock/var/lib/waydroid \
  /run/lxc/lock/var/lib/waydroid/lxc/.waydroid \
  /run/systemd/units/invocation:waydroid-container.service \
  /usr/lib/waydroid \
  /home/admin/waydroid_script \
  /home/admin/.cache/paru/clone/waydroid-image-gapps \
  /home/admin/.cache/paru/clone/waydroid-script-git \
  /home/admin/.cache/waydroid-script
