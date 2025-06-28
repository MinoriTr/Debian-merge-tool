#!/bin/bash

red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
defaut="\e[0m"
#################  TELECHARGEMENT DE TOUS LES DVD DEBIAN  #################
echo -e "${red}!!! ATTENTION, CETTE OPERATION PEUT PRENDRE DU TEMPS !!! ASSUREZ-VOUS D'AVOIR UNE CONNEXION INTERNET STABLE AINSI QUE L'ESPACE NECESSAIRE SUR VOTRE DISQUE (ENVIRON 180Go) !!!${defaut}"
read -rp "Êtes-vous sûr de vouloir continuer ? (oui/non) : " choix_operation

case $choix_operation in
    oui|Oui|OUI|o|O) 
        echo -e "${yellow}LANCEMENT DU SCRIPT${defaut}"
        ;;
    non|Non|NON|n|N) 
        echo -e "${blue}Annulation.${defaut}"; exit ;;
    *) 
        echo -e "${blue}Veuillez répondre par 'oui' ou 'non'.${defaut}"; exit 1 ;;
esac

apt install -y jigdo-file build-essential grub2 libburn-dev libisofs-dev libisoburn-dev zlib1g-dev


# Compilation de xorriso
echo -e "${yellow}PREMIERE ETAPE : INSTALLATION ET COMPILATION DE XORRISO${defaut}"
if find ./ -type d -name "xorriso*" | grep -q ; then
    echo "${blue}Xorriso déjà installé et compilé${defaut}"
else
    echo -e "${blue}Installation et compilation de Xorriso${defaut}"  
    tar xzf xorriso-1.5.6.pl02.tar.gz
    cd xorriso-1.5.6/ || exit
    ./configure --prefix=/usr && make
    make install
    cd ..
fi

# Téléchargement des ISO
echo -e "${yellow}DEUXIEME ETAPE : TELECHARGEMENT DES DVD${defaut}"
#mkdir Debian-merge && cd Debian-merge
# Téléchargement des fichiers .jigdo et récupération des ISOs
for i in {1..27}; do 
    wget "https://cdimage.debian.org/cdimage/weekly-builds/amd64/jigdo-dvd/debian-testing-amd64-DVD-${i}.jigdo" && wget "https://cdimage.debian.org/cdimage/weekly-builds/amd64/jigdo-dvd/debian-testing-amd64-DVD-${i}.template"
done

find ./ -type f -name "*.jigdo" | while read -r file; do
    jigdo-lite --noask "$file"
done

# Fusion des ISOs
echo -e "${yellow}TROISIEME ETAPE : FUSION DES DVD${defaut}"
echo -e "${blue}ISO installés. ${defaut}"
read -rp "Voulez-vous merger tous les ISOs ? (oui/non) : " choix_merge

if [[ $choix_merge =~ ^[Oo][OUI][Oui]?[oui]?$ ]]; then
    #mv ../merge_debian_isos ./
    chmod u+x merge_debian_isos
    sh merge_debian_isos debian-testing-amd64-DVD-all.iso merge_mount/iso debian-testing-amd64-DVD-*.iso
    echo -e "${green}Merge finalisé${defaut}"
    rm -rf ./xorriso-1.5.6/
    echo -e "${blue}Suppression de Xorriso${defaut}"
    for i in {1..27}; do 
        rm -f "debian-testing-amd64-DVD-${i}.jigdo" && rm "debian-testing-amd64-DVD-${i}.template"
    done
else
    echo -e "${blue}Pas de fusion, tous les ISO ont été téléchargés${defaut}"
    rm -rf ./xorriso-1.5.6/
    echo -e "${blue}Suppression de Xorriso${defaut}"
    for i in {1..27}; do 
        rm -f "debian-testing-amd64-DVD-${i}.jigdo" && rm "debian-testing-amd64-DVD-${i}.template"
    done
fi
