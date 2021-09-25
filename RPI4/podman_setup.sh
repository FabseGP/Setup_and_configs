#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------

# Dependencies

  podman network create pacman

  pip3 install pipenv
  pip3 install wheel
  pip3 install podman-compose
  sudo ln -sf /home/fabsepi/.local/bin/* /usr/bin

#----------------------------------------------------------------------------------------------------------------------------------

# Dashy

  cd /home/fabsepi/Dockers/Dashy || exit
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Docspell

  cd /home/fabsepi/Dockers/Docspell || exit
  mkdir docs
  mkdir docspell-postgres_data
  mkdir docspell-solr_data
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Exatorrent

  cd /home/fabsepi/Dockers/Exotorrent || exit
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Filebrowser

  cd /home/fabsepi/Dockers/Filebrowser || exit
  mkdir config
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Hedgedoc

  cd /home/fabsepi/Dockers/Hedgedoc || exit
  mkdir data
  mkdir config
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Navidrome

  cd /home/fabsepi/Dockers/Navidrome || exit
  mkdir data
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Nginx-proxy-manager

  cd /home/fabsepi/Dockers/Nginx-proxy-manager || exit
  mkdir data/nginx
  mkdir letsencrypt
  mkdir data/mariadb
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# OpenHAB

  cd /home/fabsepi/Dockers/OpenHAB || exit
  mkdir openhab_addons
  mkdir openhab_conf
  mkdir openhab_userdata
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Photoprism

  cd /home/fabsepi/Dockers/Photoprism || exit
  mkdir data
  mkdir database
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Sharry

  cd /home/fabsepi/Dockers/Sharry || exit
  mkdir postgres_data
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Uptime_kuma

  cd /home/fabsepi/Dockers/Uptime_kuma || exit
  mkdir uptime-kuma
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Watchtower

  cd /home/fabsepi/Dockers/Watchtower || exit
  sed -i 's|/var/run/docker.socket:/var/run/docker.socket|/var/run/podman/podman.socket:/var/run/docker.socket|g' docker-compose.yml
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Yacht

  cd /home/fabsepi/Dockers/Yacht || exit
  mkdir yacht
  podman-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Etherpad (npm)

  cd /home/fabsepi || exit
  git clone --branch master https://github.com/ether/etherpad-lite.git
  mv Dockers/Etherpad/settings.json /home/fabsepi
  rm Dockers/Etherpad/*
  mv etherpad-lite Dockers/Etherpad
  mv /home/fabsepi/settings.json Dockers/Etherpad/etherpad-lite
  cd Dockers/Etherpad/etherpad-lite || exit
  chmod u+x src/bin/run.sh
  ./src/bin/run.sh

#----------------------------------------------------------------------------------------------------------------------------------

# Leon-AI (npm)

  cd /home/fabsepi || exit
  git clone https://github.com/leon-ai/leon.git leon
  mv leon Dockers/Leon-AI
  cd Dockers/Leon-AI/leon || exit
  npm install
  npm run build