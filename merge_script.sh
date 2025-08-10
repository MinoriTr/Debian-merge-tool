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

apt install -y jigdo-file build-essential grub2 libburn-dev libisofs-dev libisoburn-dev zlib1g-dev xorriso


#COMPILATION DE XORRISO
#echo -e "${yellow}PREMIERE ETAPE : INSTALLATION ET COMPILATION DE XORRISO${defaut}"
#if find ./ -type d -name "xorriso*" | grep -q ; then
#    echo "${blue}Xorriso déjà installé et compilé${defaut}"
#else
#    echo -e "${blue}Installation et compilation de Xorriso${defaut}"
#    tar xzf xorriso-1.5.6.pl02.tar.gz
#    cd xorriso-1.5.6/ || exit
#    ./configure --prefix=/usr && make
#    make install
#    cd ..
#fi

read -rp "Voulez vous télécharger les ISOs debian (oui/non) : " choix_dl_ISOs

if [[ $choix_dl_ISOs =~ ^[Oo][Uu][Ii]$ ]]; then

    # Téléchargement des jigdo et création des ISOs
    echo -e "${yellow}DEUXIEME ETAPE : TELECHARGEMENT DES FICHIERS JIGDO ${defaut}"
    mkdir -p Debian-merge && cd Debian-merge || exit 1

    for i in {1..27}; do
        wget "https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-13.0.0-amd64-DVD-${i}.jigdo" \
         && wget "https://cdimage.debian.org/debian-cd/current/amd64/jigdo-dvd/debian-13.0.0-amd64-DVD-${i}.template"
    done

    echo -e "${yellow}TROISIEME ETAPE : CREATION DES ISOs AVEC JIGDO ${defaut}"
    find . -type f -name "*.jigdo" | while read -r file; do
        jigdo-lite --noask "$file"
    done
    echo -e "${green}ISOs téléchargés${defaut}"

else
    exit 1
fi


#Renommage des ISOs
echo -e "${yellow}Renommage des ISOs a cause de l'alpha-numérique${defaut}"
for file in debian-13.0.0-amd64-DVD-*.iso; do
    n=$(echo "$file" | grep -oP '(?<=DVD-)[0-9]+') 
    mv "$file" $(printf "debian-13.0.0-amd64-DVD-%02d.iso" "$n")
done


# Fusion des ISOs
echo -e "${yellow}QUATRIEME ETAPE : FUSION DES DVD${defaut}"
echo -e "${blue}ISOs crées. ${defaut}"
read -rp "Voulez-vous merger tous les ISOs ? (oui/non) : " choix_merge

if [[ $choix_merge =~ ^[Oo][Uu][Ii]$ ]]; then
    chmod u+x ../merge_debian_isos
    sh ../merge_debian_isos debian-13.0.0-amd64-DVD-all.iso merge_mount/iso debian-13.0.0-amd64-DVD-*.iso
    sha256sum ./debian-13.0.0-amd64-DVD-all.iso
    echo -e "${green}Checksum crée${defaut}"
    #chmod u+x ../debmerge.sh
    #bash ../debmerge.sh
    echo -e "${green}Merge finalisé${defaut}"
else
   echo -e "${blue}Pas de fusion${defaut}"
fi
