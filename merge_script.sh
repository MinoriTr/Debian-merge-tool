#!/bin/bash

red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
defaut="\e[0m"
#################  TELECHARGEMENT DE TOUS LES DVD DEBIAN  #################
echo -e "${red}!!! ATTENTION, CETTE OPERATION PEUT PRENDRE DU TEMPS !!! \nASSUREZ-VOUS D'AVOIR UNE CONNEXION INTERNET STABLE AINSI QUE L'ESPACE NECESSAIRE SUR VOTRE DISQUE !!!${defaut}"
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
    wget https://www.gnu.org/software/xorriso/xorriso-1.5.6.pl02.tar.gz
    tar xzf xorriso-1.5.6.pl02.tar.gz
    cd xorriso-1.5.6/ || exit
    ./configure --prefix=/usr && make
    make install
    cd ..
fi

# Téléchargement des ISO
echo -e "${yellow}DEUXIEME ETAPE : TELECHARGEMENT DES DVD${defaut}"

# Téléchargement des fichiers .jigdo et récupération des ISOs
find ../Debian-13-testing -type f -name "debian-testing-amd64-DVD-*.jigdo" | while read -r file; do
    jigdo-lite --noask "$file"
done

# Fusion des ISOs
echo -e "${yellow}TROISIEME ETAPE : FUSION DES DVD${defaut}"
echo -e "${blue}ISO installés. ${defaut}"
read -rp "Voulez-vous merger tous les ISOs ? (oui/non) : " choix_merge

if [[ $choix_merge =~ ^[Oo][OUI][Oui]?[oui]?$ ]]; then
    chmod u+x merge_debian_isos
    ./merge_debian_isos debian-testing-amd64-DVD-all.iso merge_mount/iso debian-testing-amd64-DVD-*.iso
    echo -e "${green}Merge finalisé${defaut}"
    rm -rf ./xorriso*
    echo -e "${blue}Suppression de Xorriso${defaut}"
else
    echo "${blue}Pas de fusion, tous les ISO ont été téléchargés${defaut}"
    rm -rf ./xorriso*
    echo -e "${blue}Suppression de Xorriso${defaut}"
fi
