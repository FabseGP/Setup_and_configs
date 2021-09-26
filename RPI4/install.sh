#!/bin/bash

# Edit repositories

  sudo rm -f /etc/apk/repositories
  sudo touch /etc/apk/repositories

  sudo bash -c 'cat > /etc/apk/repositories' << EOF
http://mirrors.dotsrc.org/alpine/edge/community/
http://mirrors.dotsrc.org/alpine/edge/testing/
http://mirrors.dotsrc.org/alpine/edge/main/
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# All packages to install

  sudo apk update
  sudo apk upgrade
  
  read -rp "Type yes to use docker, no to use podman: " docker

  if [[ "$docker" == "yes" ]]; then
    sudo apk add neofetch git py3-pip nautilus haveged kbd-bkeymaps htop curl wget i2c-tools lm_sensors perl lsblk e2fsprogs-extra networkmanager iptables bluez docker docker-compose tzdata mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol i3status fzf rclone syncthing rsync tlp terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim gammastep btrfs-progs mousepad ark vlc spectacle htop plasma podman fuse-overlayfs shadow slirp4netns nodejs-current npm lsof sddm zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde wl-clipboard gnome-calculator polkit-gnome brightnessctl pipewire-media-session scrot kdialog swaylockd
  elif [[ "$docker" == "no" ]]; then
    sudo apk add neofetch git py3-pip nautilus haveged kbd-bkeymaps htop curl wget lsblk i2c-tools lm_sensors perl e2fsprogs-extra networkmanager iptables bluez podman podman-docker tzdata py3-podman fuse-overlayfs shadow slirp4netns docker-compose mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol i3status fzf rclone syncthing rsync tlp terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim gammastep btrfs-progs mousepad ark vlc spectacle htop plasma podman fuse-overlayfs shadow slirp4netns nodejs-current npm lsof sddm zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde wl-clipboard gnome-calculator polkit-gnome brightnessctl pipewire-media-session scrot kdialog swaylockd
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Services

  if [[ "$docker" == "yes" ]]; then
    for service in fcron syncthing docker mariadb networkmanager bluetooth tlp; do
      sudo rc-update add $service default
    done
  elif [[ "$docker" == "no" ]]; then
    for service in fcron syncthing podman mariadb networkmanager bluetooth tlp; do
      sudo rc-update add $service default
    done
  fi
  sudo rc-update add swap boot
  sudo rc-update add haveged boot

#----------------------------------------------------------------------------------------------------------------------------------

# Powerlevel10k-theme

  mkdir -p ~/.local/share/fonts

  sudo lchsh fabsepi
  sudo lchsh

  touch ~/.zshrc
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc


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
    sudo addgroup --system $GRP
  done

  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    sudo adduser fabsepi $GRP 
  done

  chmod u+x Scripts/*

  sudo groupadd sftpusers
  sudo adduser sftpfabse
  sudo adduser sftpfabse sftpusers

  if [[ "$docker" == "yes" ]]; then
    sudo adduser fabsepi docker
  elif [[ "$docker" == "no" ]]; then
    sudo groupadd docker
    sudo adduser fabsepi docker
  fi

  git clone https://github.com/xmansyx/Pro-Fox.git

  sudo mkdir /media/SEAGATE

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

  sudo rm -f /etc/motd
  sudo touch /etc/motd

  sudo bash -c 'cat > /etc/motd' << EOF
  
Welcome to Alpine Linux - delivered to you by Fabse Inc.!

Proceed with caution, as puns is looming around :D

EOF

  sudo rc-service syncthing start
  syncthing
  sed -i 's/127.0.0.1/192.168.0.108/g' /home/fabsepi/.config/syncthing/config.xml

#----------------------------------------------------------------------------------------------------------------------------------

# Swapfile

  cd /
  sudo truncate -s 0 ./swapfile
  sudo chattr +C ./swapfile
  sudo btrfs property set ./swapfile compression none
 
  sudo dd if=/dev/zero of=/swapfile bs=1M count=8192
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  sudo echo '/swapfile   none    swap    sw    0   0' | sudo tee -a /etc/fstab

#----------------------------------------------------------------------------------------------------------------------------------

# usercfg.txt

  sudo touch /boot/usercfg.txt

  sudo bash -c 'cat > /boot/usercfg.txt' << EOF
dtparam=audio=on
dtparam=i2c_arm=on
dtoverlay=vc4-fkms-v3d
gpu_mem=256
enable_uart=1
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# Add fcron jobs

  sudo rc-service fcron start
  (crontab -l; echo "@reboot /home/fabsepi/Scripts/syncthing.sh")|awk '!x[$0]++'|crontab -
  (crontab -l; echo "@reboot /home/fabsepi/Scripts/leon.sh")|awk '!x[$0]++'|crontab -
  (crontab -l; echo "@reboot /home/fabsepi/Scripts/etherpad.sh")|awk '!x[$0]++'|crontab -
  sudo /bin/bash -c 'echo "@reboot /home/fabsepi/Scripts/seagate.sh" >> /etc/crontab'
  (crontab -l; echo "@reboot /home/fabsepi/Scripts/pipewire.sh")|awk '!x[$0]++'|crontab -

#----------------------------------------------------------------------------------------------------------------------------------

# Mariadb (etherpad)

  sudo /etc/init.d/mariadb setup
  sudo rc-service mariadb start
  sudo mysql_secure_installation
  
  mysql -u root -p \
  mysql -u root -p -e "CREATE database etherpad_lite_db"
  mysql -u root -p -e "CREATE USER etherpad_fabsepi@localhost identified by 'Ether54321Pad67890FABsePI'"
  mysql -u root -p -e "grant CREATE,ALTER,SELECT,INSERT,UPDATE,DELETE on etherpad_lite_db.* to etherpad_fabsepi@localhost"   
  
  sudo rc-service mariadb restart

#----------------------------------------------------------------------------------------------------------------------------------

# /etc/fstab

  sudo bash -c 'cat > /etc/fstab' << EOF
UUID=523872dd-991a-44a7-a1d4-7050b7646236       /media/SEAGATE  btrfs   defaults,noatime,autodefrag,barrier,datacow        0       3
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# cmdline.txt

  sudo sed -i 's/modules=sd-mod,usb-storage,btrfs quiet rootfstype=btrfs/modules=modules=sd-mod,usb-storage,btrfs,iptables,i2c-dev quiet rootfstype=btrfs fsck.repair cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1/' /boot/cmdline.txt

#----------------------------------------------------------------------------------------------------------------------------------

# Goodbye

  echo
  echo "And you're welcome :))"
  echo
