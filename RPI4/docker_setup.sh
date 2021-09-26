#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------

# Dependencies

  docker network create pacman

  pip3 install pipenv
  pip3 install wheel
  sudo ln -sf /home/fabsepi/.local/bin/* /usr/bin

#----------------------------------------------------------------------------------------------------------------------------------

# Dashy

  cd /home/fabsepi/Dockers/Dashy || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Docspell

  cd /home/fabsepi/Dockers/Docspell || exit
  mkdir docs
  mkdir docspell-postgres_data
  mkdir docspell-solr_data
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Exatorrent

  cd /home/fabsepi/Dockers/Exotorrent || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Filebrowser

  cd /home/fabsepi/Dockers/Filebrowser || exit
  mkdir config
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Grafana

  cd /home/fabsepi/Dockers/Grafana || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Hedgedoc

  cd /home/fabsepi/Dockers/Hedgedoc || exit
  mkdir data
  mkdir config
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Navidrome

  cd /home/fabsepi/Dockers/Navidrome || exit
  mkdir data
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Netdata

  cd /home/fabsepi/Dockers/Netdata || exit
  mkdir netdatalib
  mkdir netdatacache
  mkdir -p netdataconfig/netdata
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Nginx-proxy-manager

  cd /home/fabsepi/Dockers/Nginx-proxy-manager || exit
  mkdir -p data/nginx
  mkdir letsencrypt
  mkdir -p data/mariadb
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# OpenHAB

  cd /home/fabsepi/Dockers/OpenHAB || exit
  mkdir openhab_addons
  mkdir openhab_conf
  mkdir openhab_userdata
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Photoprism

  cd /home/fabsepi/Dockers/Photoprism || exit
  mkdir data
  mkdir database
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Prometheus

  cd /home/fabsepi/Dockers/Prometheus || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Sharry

  cd /home/fabsepi/Dockers/Sharry || exit
  mkdir postgres_data
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Uptime_kuma

  cd /home/fabsepi/Dockers/Uptime_kuma || exit
  mkdir uptime-kuma
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Watchtower

  cd /home/fabsepi/Dockers/Watchtower || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Yacht

  cd /home/fabsepi/Dockers/Yacht || exit
  mkdir yacht
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Vikunja

  cd /home/fabsepi/Dockers/Vikunja || exit
  mkdir files
  docker-compose up -d

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
  npm install ep_align && npm install ep_font_size && npm install ep_font_color && npm install ep_comments_page && npm install ep_headings2 && npm install ep_table_of_contents && npm install ep_set_title_on_pad && npm install ep_hash_auth && npm install ep_who_did_what && npm install ep_what_have_i_missed && npm install ep_offline_edit && npm install ep_image_upload

#----------------------------------------------------------------------------------------------------------------------------------

# Leon-AI (npm)

  cd /home/fabsepi || exit
  mv Dockers/Leon-AI/.env /home/fabsepi
  rm Dockers/Leon-AI/*
  git clone https://github.com/leon-ai/leon.git leon
  mv leon Dockers/Leon-AI
  mv .env Dockers/Leon-AI/leon
  cd Dockers/Leon-AI/leon || exit
  npm install
  npm run build
