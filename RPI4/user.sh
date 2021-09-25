#!/bin/bash

# Regular user

  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done

  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    adduser fabsepi $GRP 
  done
