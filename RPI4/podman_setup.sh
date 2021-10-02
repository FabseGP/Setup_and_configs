#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------

# Dependencies

  podman network create pacman

  pip3 install pipenv
  pip3 install wheel
  sudo ln -sf /home/fabsepi/.local/bin/* /usr/bin

#----------------------------------------------------------------------------------------------------------------------------------

# Archivebox

  cd /home/fabsepi/Dockers/DashyArchiveBox || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Cryptofolio

  cd /home/fabsepi/Dockers/Cryptofolio || exit
  mkdir data
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Dashy

  cd /home/fabsepi/Dockers/Dashy || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Docspell

  cd /home/fabsepi/Dockers/Docspell || exit
  mkdir docs
  mkdir docspell-postgres_data
  mkdir docspell-solr_data
  export DOCSPELL_HEADER_VALUE=7hd737sghs7afsus7sgsj
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Exatorrent

  cd /home/fabsepi/Dockers/Exotorrent || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Filebrowser

  cd /home/fabsepi/Dockers/Filebrowser || exit
  mkdir config
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Firefly

  cd /home/fabsepi/Dockers/Firefly || exit
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Grafana

  cd /home/fabsepi/Dockers/Grafana || exit
  docker volume create grafana-storage
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Hedgedoc

  cd /home/fabsepi/Dockers/Hedgedoc || exit
  mkdir data
  mkdir config
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Navidrome

  cd /home/fabsepi/Dockers/Navidrome || exit
  mkdir data
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Netdata

  cd /home/fabsepi/Dockers/Netdata || exit
  mkdir netdatalib
  mkdir netdatacache
  mkdir -p netdataconfig/netdata
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Nginx-proxy-manager

  cd /home/fabsepi/Dockers/Nginx-proxy-manager || exit
  mkdir -p data/nginx
  mkdir letsencrypt
  mkdir -p data/mariadb
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# OpenHAB

  cd /home/fabsepi/Dockers/OpenHAB || exit
  mkdir openhab_addons
  mkdir openhab_conf
  mkdir openhab_userdata
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Photoprism

  cd /home/fabsepi/Dockers/Photoprism || exit
  mkdir data
  mkdir database
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Prometheus

  cd /home/fabsepi/Dockers/Prometheus || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Sharry

  cd /home/fabsepi/Dockers/Sharry || exit
  mkdir postgres_data
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Uptime_kuma

  cd /home/fabsepi/Dockers/Uptime_kuma || exit
  mkdir uptime-kuma
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Vikunja

  cd /home/fabsepi/Dockers/Vikunja || exit
  mkdir files
  mkdir db
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Watchtower

  cd /home/fabsepi/Dockers/Watchtower || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Wiki_js

  cd /home/fabsepi/Dockers/Wiki.js || exit
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Yacht

  cd /home/fabsepi/Dockers/Yacht || exit
  mkdir yacht
  DOCKER_HOST=unix:///run/podman/podman.sock docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Etherpad (npm)

  cd /home/fabsepi
  git clone --branch develop https://github.com/ether/etherpad-lite.git
  mv Dockers/Etherpad/settings.json /home/fabsepi
  rm Dockers/Etherpad/*
  mv etherpad-lite Dockers/Etherpad
  mv /home/fabsepi/settings.json Dockers/Etherpad/etherpad-lite
  cd Dockers/Etherpad/etherpad-lite || exit
  chmod u+x src/bin/run.sh
  ./src/bin/run.sh
  export NODE_ENV=production
  npm install ep_align ep_font_size ep_font_color ep_comments_page ep_headings2 ep_table_of_contents ep_set_title_on_pad ep_who_did_what ep_what_have_i_missed ep_offline_edit ep_image_upload
  npm audit fix
  npm update -g
  
#----------------------------------------------------------------------------------------------------------------------------------

# Leon-AI (npm)

  cd /home/fabsepi || exit
  mv Dockers/Leon-AI/.env /home/fabsepi
  rm Dockers/Leon-AI/*
  git clone https://github.com/leon-ai/leon.git leon
  mv leon Dockers/Leon-AI
  mv .env Dockers/Leon-AI/leon
  cd Dockers/Leon-AI/leon || exit
  npm install --save-dev @babel/node
  npm install -g node-gyp
  npm install
  npm run build
  npm audit fix
