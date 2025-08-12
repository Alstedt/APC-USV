#!/bin/bash

case "$SSH_ORIGINAL_COMMAND" in
  *proxmox-backup-client\ task\ list* )
    exec $SSH_ORIGINAL_COMMAND
    ;;
  *proxmox-backup-client\ task\ stop* )
    exec $SSH_ORIGINAL_COMMAND
    ;;
  systemctl\ poweroff* )
    exec $SSH_ORIGINAL_COMMAND
    ;;
  * )
    echo "Fehler: Befehl nicht erlaubt"
    exit 1
    ;;
esac
