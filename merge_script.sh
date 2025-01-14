#!/bin/bash

#################  TELECHARGEMENT DE TOUS LES DVD DEBIAN-12  #################
echo "ATTENTION, ASSUREZ-VOUS D'AVOIR UNE CONNEXION INTERNET STABLE AINSI QUE L'ESPACE NECESSAIRE SUR VOTRE DISQUE (ENVIRON 180Go)"
apt install -y jigdo-file build-essential grub2 libburn-dev libisofs-dev libisoburn-dev zlib1g-dev

# Compilation de xorriso

wget https://www.gnu.org/software/xorriso/xorriso-1.5.6.pl02.tar.gz

tar xzf xorriso-1.5.6.pl02.tar.gz

cd xorriso-1.5.6/
./configure --prefix=/usr && make

make install

cd ..

#Création du répertoire de dépot

#mkdir Debian-Repo
# cd /Debian-Repo

# Téléchargement des ISO
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-1.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-2.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-3.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-4.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-5.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-6.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-7.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-8.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-9.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-10.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-11.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-12.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-13.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-14.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-15.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-16.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-17.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-18.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-19.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-20.jigdo
jigdo-lite --noask https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-12.8.0-amd64-DVD-21.jigdo

chmod u+x merge_debian_isos
./merge_debian_isos debian-12.8.0-amd64-DVD-all.iso merge_mount/iso debian-12.8.0-amd64-DVD-*.iso