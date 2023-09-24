#!/bin/bash

# Додайте репозиторій backports
echo "deb http://deb.debian.org/debian bookworm-backports main contrib" | sudo tee /etc/apt/sources.list.d/bookworm-backports.list
echo "deb-src http://deb.debian.org/debian bookworm-backports main contrib" | sudo tee -a /etc/apt/sources.list.d/bookworm-backports.list

# Створіть файл налаштувань для забезпечення пріоритету для пакету zfs-linux
echo "Package: src:zfs-linux" | sudo tee /etc/apt/preferences.d/90_zfs
echo "Pin: release n=bookworm-backports" | sudo tee -a /etc/apt/preferences.d/90_zfs
echo "Pin-Priority: 990" | sudo tee -a /etc/apt/preferences.d/90_zfs

# Оновіть список пакетів
sudo apt update

# Встановіть необхідні пакети
sudo apt install dpkg-dev linux-headers-generic linux-image-generic
sudo apt install zfs-dkms zfsutils-linux

echo "Встановлено ZFS та інші необхідні пакети."
