#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------

# Dashy

  cd /home/fabsepi/Dockers/Dashy
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Docspell

  cd /home/fabsepi/Dockers/Docspell
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Etherpad (npm)

  git clone --branch master https://github.com/ether/etherpad-lite.git
  mv etherpad-lite Dockers/Etherpad
  mv Setup_and_configs/RPI4/Dockers/Etherpad/settings.json Dockers/Etherpad/etherpad-lite
  cd Dockers/Etherpad/etherpad-lite
  chmod u+x src/bin/run.sh
  ./src/bin/run.sh

#----------------------------------------------------------------------------------------------------------------------------------

# Exatorrent

  cd /home/fabsepi/Dockers/Exotorrent
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Filebrowser

  cd /home/fabsepi/Dockers/Filebrowser
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Hedgedoc

  cd /home/fabsepi/Dockers/Hedgedoc
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Leon-AI (npm)

  git clone --branch master https://github.com/leon-ai/leon.git leon
  mv leon Dockers/Leon-AI
  cd Dockers/Leon-AI/leon
  pip3 install pipenv
  npm install
  npm run build

#----------------------------------------------------------------------------------------------------------------------------------

# Nginx-proxy-manager

  cd /home/fabsepi/Dockers/Nginx-proxy-manager
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# OpenHAB

  cd /home/fabsepi/Dockers/OpenHAB
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Photoprism

  cd /home/fabsepi/Dockers/Photoprism
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Sharry

  cd /home/fabsepi/Dockers/Sharry
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Uptime_kuma

  cd /home/fabsepi/Dockers/Uptime_kuma
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Watchtower

  cd /home/fabsepi/Dockers/Watchtower
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------

# Yacht

  cd /home/fabsepi/Dockers/Yacht
  docker-compose up -d

#----------------------------------------------------------------------------------------------------------------------------------
