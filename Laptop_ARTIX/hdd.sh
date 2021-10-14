#!/usr/bin/bash

  DRIVE_PATH="/dev/sda"
  BACKUP_FOLDER="/mnt/FABSE_GATE/hello/*"

  echo 'permit nopass fabse' | doas tee -a /etc/doas.conf > /dev/null

  doas mount "$DRIVE_PATH" /mnt
  doas cp -r "$BACKUP_FOLDER" /home/fabse
  doas umount /mnt
  doas chown -R fabse:wheel /home/fabse/{Baggrunde,Billeder,Diverse,Documents,Konfiguration,Musik,Pictures,Skærmbilleder,Syncthing-backups,Videoklip,Virtualbox_images}
  
