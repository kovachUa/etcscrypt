#!/bin/bash

# Додати репозиторій backports
echo "deb http://deb.debian.org/debian bullseye-backports main contrib" >> /etc/apt/sources.list.d/bullseye-backports.list
echo "deb-src http://deb.debian.org/debian bullseye-backports main contrib" >> /etc/apt/sources.list.d/bullseye-backports.list

# Додати пріоритет для пакету ZFS
echo "Package: src:zfs-linux
Pin: release n=bullseye-backports
Pin-Priority: 990" >> /etc/apt/preferences.d/90_zfs

# Оновити список пакетів
apt update

# Встановити необхідні пакети
apt install -y dpkg-dev linux-headers-generic linux-image-generic zfs-dkms zfsutils-linux

# Вивести повідомлення про завершення встановлення
echo "Встановлення пакетів ZFS завершено."

