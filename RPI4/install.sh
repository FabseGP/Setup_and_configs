#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------

# All packages to install

  sudo apk add neofetch git nautilus podman-remote mysql-client firefox mysql pipewire lftp podman-docker ttf-opensans buildah pipewire-pulse docker-compose libuser ksysguard libreoffice pavucontrol py3-podman py3-pip shadow fuse-overlayfs slirp4netns i3status fzf rclone syncthing rsync tlp terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim gammastep btrfs-progs mousepad ark vlc spectacle htop plasma podman fuse-overlayfs shadow slirp4netns nodejs npm lsof sddm zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde wl-clipboard gnome-calculator polkit-gnome brightnessctl pipewire-media-session scrot kdialog swaylockd

#----------------------------------------------------------------------------------------------------------------------------------

# Pipewire

  mkdir /etc/pipewire
  cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

#----------------------------------------------------------------------------------------------------------------------------------

# Services

  for service in fcron syncthing docker mariadb tlp; do
    sudo rc-update add $service default
  done

#----------------------------------------------------------------------------------------------------------------------------------

# Powerlevel10/k-theme

  mkdir ~/.local/share/fonts

  sudo lchsh fabsepi
  sudo lchsh

  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

#----------------------------------------------------------------------------------------------------------------------------------

# Extra's

  chmod u+x Scripts/*

  sudo groupadd sftpusers
  sudo adduser sftpfabse sftpusers

  git clone https://github.com/xmansyx/Pro-Fox.git
  git clone --branch master https://github.com/ether/etherpad-lite.git
  git clone -b master https://github.com/leon-ai/leon.git leon

  sudo rm -rf /home/fabse

  sudo addgroup docker fabsepi

  sudo mkdir /media/SEAGATE

  sudo passwd root
