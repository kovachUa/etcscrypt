#!/bin/bash

# Оновити пакетні репозиторії
sudo apt update

# Встановити необхідні пакети
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager

# Додати користувача до групи libvirt
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG libvirt-qemu $(whoami)

# Налаштувати libvirtd.conf
sudo sed -i '/^#unix_sock_group/s/^#//' /etc/libvirt/libvirtd.conf
sudo sed -i '/^#unix_sock_rw_perms/s/^#//' /etc/libvirt/libvirtd.conf
sudo sed -i '/^#unix_sock_ro_perms/s/^#//' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^listen_tls = 1/listen_tls = 0/' /etc/libvirt/libvirtd.conf
sudo sed -i 's/^listen_tcp = 0/listen_tcp = 1/' /etc/libvirt/libvirtd.conf

# Налаштувати мережу
sudo sed -i '/^# The primary network interface/s/^#//' /etc/network/interfaces
sudo sed -i '/^# bridge ports/s/^# //' /etc/network/interfaces

# Перезавантажити мережеві налаштування
sudo systemctl restart networking

# Перевірити та активувати сервіси
sudo systemctl is-active libvirtd
sudo systemctl is-active virtlogd
