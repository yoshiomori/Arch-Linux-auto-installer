#!/bin/sh
# This is a arch linux installer.

# Supondo que o teclado é do formato abnt2, o idioma é português brasileiro
# e que a versão do arch é 2014.02.01
loadkeys br-abnt2
if [ -f locale.gen.aux ]; then
        rm locale.gen.aux
fi
while read line;
do
if [ "$line" == "#pt_BR.UTF-8 UTF-8" ]; then
        echo "pt_BR.UTF-8 UTF-8" >> locale.gen.aux
else
        echo "$line" >> locale.gen.aux
fi
done < /etc/locale.gen
mv -f locale.gen.aux /etc/locale.gen
locale-gen
export LANG=pt_BR.UTF-8

# Preparando o disco supondo que o device file do disco da instalação é o sda
sgdisk -og /dev/sda
sgdisk -n 1:2048:1050623 -c 1:"EFI System" -t 1:ef00 /dev/sda
sgdisk -n 2:1050624:17827839 -c 2:"Linux swap" -t 2:8200 /dev/sda
sgdisk -n 3:17827840:49285119 -c 3:"Linux filesystem" -t 3:8300 /dev/sda
sgdisk -n 4:49285120:976773134 -c 4:"Linux /home" -t 4:8302 /dev/sda

# Formatando
mkfs.fat -F32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
mkfs.ext4 /dev/sda4

# Montando
swapon /dev/sda2
mount /dev/sda3 /mnt
mkdir /mnt/boot /mnt/home
mount /dev/sda1 /mnt/boot
mount /dev/sda4 /mnt/home

# Supondo que já tenha o arquivo mirrorlist nas mãos
# Configurando o mirror do pacman
mv -f mirrorlist /etc/pacman.d/mirrorlist

# Instalando
pacstrap /mnt base base-devel

genfstab -U -p /mnt >> /mnt/etc/fstab
nano /mnt/etc/fstab

arch-chroot /mnt /bin/bash

if [ -f locale.gen.aux ]; then
        rm locale.gen.aux
fi
while read line;
do
if [ "$line" == "#pt_BR.UTF-8 UTF-8" ]; then
        echo "pt_BR.UTF-8 UTF-8" >> locale.gen.aux
else
        echo "$line" >> locale.gen.aux
fi
done < /etc/locale.gen

while read line;
do
if [ "$line" == "#en_US.UTF-8 UTF-8" ]; then
        echo "en_US.UTF-8 UTF-8" >> locale.gen.aux.aux
else
        echo "$line" >> locale.gen.aux.aux
fi
done < locale.gen.aux
rm locale.gen.aux
mv -f locale.gen.aux.aux /etc/locale.gen
locale-gen
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8
loadkeys br-abnt2
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
