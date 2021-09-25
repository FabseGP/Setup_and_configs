#!/bin/bash

# Regular user

  apk add sudo git

  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done

  adduser -s /bin/sh -D fabsepi

  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    adduser $FIRST_USER_NAME $GRP 
  done

  echo "fabsepi:Alpine54321Linux67890" | /usr/sbin/chpasswd

  echo "%wheel ALL=(ALL) ALL" | (EDITOR="tee -a" visudo)
