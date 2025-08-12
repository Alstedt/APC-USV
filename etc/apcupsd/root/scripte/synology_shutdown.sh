!/bin/bash
# Synology NAS per SSH sicher herunterfahren mit PBS-Job-Stop und VM-Shutdown

# Konfiguration
PBS_VM_USER="???"                   # Benutzer auf PBS-VM
PBS_VM_IP="XXX.XXX.XXX.XX"            # PBS-VM-IP
NAS_USER="???"                     # Synology-Admin
NAS_IP="XXX.XXX.XXX.XX"               # Synology-IP
SSH_KEY="/root/.ssh/id_rsa_synology"  # Schlüssel für SSH Zugang auf den Servern, erlaubte Aktionen einschränken per Wrapper Skript!!!

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

log "Starte Stoppen der PBS Backup-Jobs"

# Auf PBS-VM: Alle laufenden Tasks abfragen und stoppen
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$PBS_VM_USER@$PBS_VM_IP" bash -c '
    echo "PBS Backup-Jobs werden gestoppt..."
    # Liste aller laufenden Tasks holen (nur UPIDs ausgeben, Kopfzeile überspringen):
    for upid in $(proxmox-backup-client task list | awk "NR>1 {print \$1}")
    do
        echo "Stoppe Task $upid ..."
        proxmox-backup-client task stop "$upid"
    done
'

log "Warte 60 Sekunden bis alle PBS Backup-Jobs beendet sind"
sleep 60

log "Fahre PBS VM herunter"
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$PBS_VM_USER@$PBS_VM_IP" systemctl poweroff

log "Starte Synology NAS Shutdown"
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$NAS_USER@$NAS_IP" sudo /sbin/poweroff

log "Synology NAS Shutdown-Befehl abgeschickt. Script beendet."
