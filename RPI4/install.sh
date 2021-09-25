#!/bin/bash

# Edit repositories

  rm -f /etc/apk/repositories
  touch /etc/apk/repositories

  cat <<EOF > /etc/apk/repositories
http://mirrors.dotsrc.org/alpine/edge/community/
http://mirrors.dotsrc.org/alpine/edge/testing/
http://mirrors.dotsrc.org/alpine/edge/main/
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# All packages to install

  apk update
  read -rp "Type yes to use docker, no to use podman" docker

  if [[ "$docker" == "yes" ]]; then
    apk add neofetch git py3-pip nautilus kbd-bkeymaps htop curl wget lsblk bash e2fsprogs-extra networkmanager iptables bluez docker docker-compose tzdata mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol i3status fzf rclone syncthing rsync tlp terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim gammastep btrfs-progs mousepad ark vlc spectacle htop plasma podman fuse-overlayfs shadow slirp4netns nodejs npm lsof sddm zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde wl-clipboard gnome-calculator polkit-gnome brightnessctl pipewire-media-session scrot kdialog swaylockd
  elif [[ "$docker" == "no" ]]; then
    apk add neofetch git py3-pip nautilus kbd-bkeymaps htop curl wget lsblk bash e2fsprogs-extra networkmanager iptables bluez podman podman-docker tzdata py3-podman fuse-overlayfs shadow slirp4netns docker-compose mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol i3status fzf rclone syncthing rsync tlp terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim gammastep btrfs-progs mousepad ark vlc spectacle htop plasma podman fuse-overlayfs shadow slirp4netns nodejs npm lsof sddm zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde wl-clipboard gnome-calculator polkit-gnome brightnessctl pipewire-media-session scrot kdialog swaylockd
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Pipewire

  cp /usr/share/pipewire/pipewire.conf /etc/pipewire/

#----------------------------------------------------------------------------------------------------------------------------------

# Services

  if [[ "$docker" == "yes" ]]; then
    for service in fcron syncthing docker mariadb networkmanager bluetooth tlp; do
      rc-update add $service default
    done
  elif [[ "$docker" == "no" ]]; then
    for service in fcron syncthing podman mariadb networkmanager bluetooth tlp; do
      rc-update add $service default
    done
  fi
  rc-update add swap boot

#----------------------------------------------------------------------------------------------------------------------------------

# Powerlevel10k-theme

  mkdir -p ~/.local/share/fonts

  lchsh fabsepi
  lchsh

  touch ~/.zshrc
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

#----------------------------------------------------------------------------------------------------------------------------------

# Extra's
  
  mv Setup_and_configs/RPI4/Scripts /home/fabsepi
  mv Setup_and_configs/RPI4/Dockers /home/fabsepi

  if [[ "$docker" == "yes" ]]; then
    mv Setup_and_configs/RPI4/docker_setup.sh /home/fabsepi
    chmod u+x docker_setup.sh
  elif [[ "$docker" == "no" ]]; then
    mv Setup_and_configs/RPI4/podman_setup.sh /home/fabsepi
    chmod u+x podman_setup.sh
  fi
  
  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done

  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    adduser fabsepi $GRP 
  done

  chmod u+x Scripts/*

  groupadd sftpusers
  adduser sftpfabse
  adduser sftpfabse sftpusers

  if [[ "$docker" == "yes" ]]; then
    adduser fabsepi docker
  elif [[ "$docker" == "no" ]]; then
    groupadd docker
    adduser fabsepi docker
  fi

  git clone https://github.com/xmansyx/Pro-Fox.git

  mkdir /media/SEAGATE
  passwd root

  cat << EOF > .zshrc
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

  cat << EOF > .bashrc
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# Swapfile

  cd /
  truncate -s 0 ./swapfile
  chattr +C ./swapfile
  btrfs property set ./swapfile compression none
 
  dd if=/dev/zero of=/swapfile bs=1M count=8192
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab

#----------------------------------------------------------------------------------------------------------------------------------

# usercfg.txt

  touch /boot/usercfg.txt

  cat <<EOF > /boot/usercfg.txt
enable_gic=1
dtparam=audio=on
dtoverlay=vc4-fkms-v3d
gpu_mem=256
enable_uart=1
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# Add fcron jobs

   (crontab -l; echo "@reboot /home/fabsepi/Scipts/syncthing.sh")|awk '!x[$0]++'|crontab -
   (crontab -l; echo "@reboot /home/fabsepi/Scipts/leon.sh")|awk '!x[$0]++'|crontab -
   (crontab -l; echo "@reboot /home/fabsepi/Scipts/etherpad.sh")|awk '!x[$0]++'|crontab -
   (crontab -l; echo "@reboot /home/fabsepi/Scipts/seagate.sh")|awk '!x[$0]++'|crontab -
   (crontab -l; echo "@reboot /home/fabsepi/Scipts/pipewire.sh")|awk '!x[$0]++'|crontab -

#----------------------------------------------------------------------------------------------------------------------------------

# Goodbye

  echo "Add this to /boot/cmdline.txt":
  echo
  echo "modules=...btrfs,ip_tables fsck.repair cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1"
  echo

  echo "Add this to /etc/fstab":
  echo
  echo "UUID=523872dd-991a-44a7-a1d4-7050b7646236       /media/SEAGATE  btrfs   defaults,noatime,autodefrag,barrier,datacow        0       3"
  echo

  echo "And you're welcome :))"
  echo
