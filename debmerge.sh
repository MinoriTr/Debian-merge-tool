#!/bin/bash
set -euo pipefail

# === CONFIGURATION PAR DÉFAUT ===
KEEP_TEMP=false
DRY_RUN=false
LOGFILE="merge.log"
OUTPUT=""
MNT_DIR="mnt"
WORK_DIR="CD1"

log() { echo "[$(date +'%H:%M:%S')] $*" | tee -a "$LOGFILE"; }
err() { log "ERREUR: $*"; exit 1; }

# === OPTIONS ===
while [[ $# -gt 0 ]]; do
  case $1 in
    --keep-temp) KEEP_TEMP=true ;;
    --dry-run) DRY_RUN=true ;;
    --output) shift; OUTPUT="$1" ;;
    *) err "Option inconnue: $1" ;;
  esac
  shift
done

# === DÉTECTION DES ISOs ===
ISOS=(debian-*-amd64-DVD-*.iso)
[[ ${#ISOS[@]} -eq 0 ]] && err "Aucun ISO trouvé (debian-*-amd64-DVD-*.iso)."

# === DÉDUCTION DE LA VERSION/ARCH ===
BASE=$(basename "${ISOS[0]}")
VERSION=$(echo "$BASE" | grep -oP '(?<=debian-)[0-9]+\.[0-9]+\.[0-9]+')
ARCH=$(echo "$BASE" | grep -oP '(?<=-amd64)')
OUTPUT=${OUTPUT:-"debian-${VERSION}-${ARCH}-merged.iso"}

log "Fichiers détectés : ${ISOS[*]}"
log "Version Debian : $VERSION / Architecture : $ARCH"
log "ISO final : $OUTPUT"

[[ "$DRY_RUN" == true ]] && { log "Mode simulation activé. Aucun fichier modifié."; exit 0; }

# === DÉPENDANCES ===
for cmd in losetup mount umount xorriso dd; do
    command -v $cmd >/dev/null || err "$cmd est requis."
done

# === PRÉPARATION ===
log "Nettoyage des anciens fichiers."
rm -rf "$WORK_DIR" "$MNT_DIR" isolinux.bin "$OUTPUT"
mkdir -p "$WORK_DIR" "$MNT_DIR"

# === EXTRACTION DU BOOT SECTEUR ===
dd if="${ISOS[0]}" of=isolinux.bin bs=1 count=432 status=none

merge_disc() {
    local iso="$1"
    log "Fusion de $iso"
    LOOPDEV=$(sudo losetup -f)
    sudo losetup "$LOOPDEV" "$iso"
    sudo mount "$LOOPDEV" "./$MNT_DIR" -o ro
    cp -a "$MNT_DIR"/* "$WORK_DIR"/
    sudo umount "$LOOPDEV"
    sudo losetup -d "$LOOPDEV"
    sudo chmod -R u+w "$WORK_DIR/"
}

for iso in "${ISOS[@]}"; do merge_disc "$iso"; done

# === CHECKSUMS ===
log "Recréation des checksums."
( cd "$WORK_DIR" && find . -type f | sort | xargs md5sum ) > md5sum.txt

# === GÉNÉRATION ISO ===
log "Génération de l’ISO final."
xorriso -as mkisofs -r -V "Debian ${VERSION} ${ARCH} merged" \
    -o "$OUTPUT" -J -joliet-long \
    -isohybrid-mbr isolinux.bin -b isolinux/isolinux.bin \
    -c isolinux/boot.cat -boot-load-size 4 -boot-info-table \
    -no-emul-boot "$WORK_DIR"

# === NETTOYAGE ===
[[ "$KEEP_TEMP" == false ]] && rm -rf "$WORK_DIR" "$MNT_DIR" isolinux.bin

log "ISO généré : $OUTPUT"
