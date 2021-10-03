#!/usr/bin/bash

  read -rp "Is script executed as sudo bash ./install.sh? Type either yes or no: " pacman
  if [[ "$pacman" == "no" ]]; then
    exit 1
  fi
  
  read -rp "Type yes to use docker, no to use podman: " docker

# Edit repositories

  rm -f /etc/apk/repositories
  touch /etc/apk/repositories

  bash -c 'cat > /etc/apk/repositories' << EOF
http://mirrors.dotsrc.org/alpine/edge/community/
http://mirrors.dotsrc.org/alpine/edge/testing/
http://mirrors.dotsrc.org/alpine/edge/main/
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# All packages to install

  apk update
  apk upgrade
  
  if [[ "$docker" == "yes" ]]; then
    apk add neofetch git py3-pip nautilus haveged alpine-sdk kbd-bkeymaps curl wget i2c-tools lm_sensors perl lsblk e2fsprogs-extra networkmanager iptables docker docker-cli-compose tzdata mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol yambar fuzzel rclone syncthing rsync terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim btrfs-progs mousepad ark mpv swappy glances plasma nodejs-current npm lsof zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde clipman gnome-calculator polkit-gnome pipewire-media-session grim kdialog swaylockd
  elif [[ "$docker" == "no" ]]; then
    apk add neofetch git py3-pip nautilus haveged alpine-sdk kbd-bkeymaps curl wget lsblk i2c-tools lm_sensors perl e2fsprogs-extra networkmanager iptables podman podman-docker tzdata py3-podman podman-remote fuse-overlayfs shadow slirp4netns mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol yambar fuzzel rclone syncthing rsync terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim btrfs-progs mousepad ark mpv swappy glances plasma nodejs-current npm lsof zathura zathura-pdf-poppler eudev sway swaylock swayidle mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde clipman gnome-calculator polkit-gnome pipewire-media-session grim kdialog swaylockd
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Services

  if [[ "$docker" == "yes" ]]; then
    for service in fcron syncthing docker mariadb fuse iptables networkmanager; do
      rc-update add $service default
    done
  elif [[ "$docker" == "no" ]]; then
    for service in fcron syncthing podman mariadb fuse iptables networkmanager; do
      rc-update add $service default
    done
    rc-service podman start
    modprobe tun
    usermod --add-subuids 100000-165535 fabsepi
    usermod --add-subgids 100000-165535 fabsepi
    podman system migrate
  fi
  rc-update add swap boot
  rc-update add haveged boot
  
  /etc/init.d/iptables save

#----------------------------------------------------------------------------------------------------------------------------------

# Powerlevel10k-theme

  sudo --user=fabsepi mkdir -p /home/fabsepi/.local/share/fonts

  lchsh fabsepi
  lchsh

  sudo --user=fabsepi touch /home/fabsepi/.zshrc
  sudo --user=fabsepi git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/fabsepi/powerlevel10k
  sudo --user=fabsepi echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' | sudo --user=fabsepi tee -a /home/fabsepi/.zshrc > /dev/null


#----------------------------------------------------------------------------------------------------------------------------------

# User and groups

  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done

  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    adduser fabsepi $GRP 
  done

  sudo --user=fabsepi chmod u+x /home/fabsepi/Scripts/*

  groupadd sftpusers
  adduser sftpfabse
  adduser sftpfabse sftpusers

  if [[ "$docker" == "yes" ]]; then
    adduser fabsepi docker
  elif [[ "$docker" == "no" ]]; then
    groupadd docker
    adduser fabsepi docker
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Extra's

  sudo --user=fabsepi mv /home/fabsepi/Setup_and_configs/RPI4/Scripts /home/fabsepi
  sudo --user=fabsepi mv /home/fabsepi/Setup_and_configs/RPI4/Dockers /home/fabsepi

  if [[ "$docker" == "yes" ]]; then
    sudo --user=fabsepi mv /home/fabsepi/Setup_and_configs/RPI4/docker_setup.sh /home/fabsepi
    sudo --user=fabsepi chmod u+x /home/fabsepi/docker_setup.sh
  elif [[ "$docker" == "no" ]]; then
    sudo --user=fabsepi mv /home/fabsepi/Setup_and_configs/RPI4/podman_setup.sh /home/fabsepi
    sudo --user=fabsepi chmod u+x /home/fabsepi/podman_setup.sh
  fi

  sudo --user=fabsepi git clone https://github.com/xmansyx/Pro-Fox.git /home/fabsepi/Pro-Fox

  mkdir /media/SEAGATE

  cat << EOF | sudo --user=fabsepi tee -a /home/fabsepi/.zshrc > /dev/null
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

  cat << EOF | sudo --user=fabsepi tee -a /home/fabsepi/.bashrc > /dev/null
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
EOF

  rm -f /etc/motd
  touch /etc/motd

  bash -c 'cat > /etc/motd' << EOF
  
Welcome to Alpine Linux - delivered to you by Fabse Inc.!

Proceed with caution, as puns is looming around :D

EOF

  rc-service syncthing start
  sudo --user=fabsepi syncthing
  sudo --user=fabsepi sed -i 's/127.0.0.1/192.168.0.108/g' /home/fabsepi/.config/syncthing/config.xml

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
  echo '/swapfile   none    swap    sw    0   0' | sudo tee -a /etc/fstab > /dev/null

#----------------------------------------------------------------------------------------------------------------------------------

# usercfg.txt

  touch /boot/usercfg.txt

  bash -c 'cat > /boot/usercfg.txt' << EOF
dtparam=audio=on
dtparam=i2c_arm=on
dtoverlay=vc4-fkms-v3d
gpu_mem=256
enable_uart=1
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# Add fcron jobs

  rc-service fcron start
  sudo --user=fabsepi (crontab -l; echo "@reboot /home/fabsepi/Scripts/syncthing.sh")|awk '!x[$0]++'|crontab -
  sudo --user=fabsepi (crontab -l; echo "@reboot /home/fabsepi/Scripts/leon.sh")|awk '!x[$0]++'|crontab -
  sudo --user=fabsepi (crontab -l; echo "@reboot /home/fabsepi/Scripts/etherpad.sh")|awk '!x[$0]++'|crontab -
  /bin/bash -c 'echo "@reboot /home/fabsepi/Scripts/seagate.sh" >> sudo /etc/crontab'
  sudo --user=fabsepi (crontab -l; echo "@reboot /home/fabsepi/Scripts/pipewire.sh")|awk '!x[$0]++'|crontab -

#----------------------------------------------------------------------------------------------------------------------------------

# Mariadb (etherpad)

  /etc/init.d/mariadb setup
  rc-service mariadb start
  mysql_secure_installation
  
  sudo --user=fabsepi mysql -u root --password=Alpine54321DB67890Maria -e "CREATE database etherpad_lite_db"
  sudo --user=fabsepi mysql -u root --password=Alpine54321DB67890Maria -e "CREATE USER etherpad_fabsepi@localhost identified by 'Ether54321Pad67890FABsePI'"
  sudo --user=fabsepi mysql -u root --password=Alpine54321DB67890Maria -e "grant CREATE,ALTER,SELECT,INSERT,UPDATE,DELETE on etherpad_lite_db.* to etherpad_fabsepi@localhost"   
  
  rc-service mariadb restart

#----------------------------------------------------------------------------------------------------------------------------------

# /etc/fstab

  echo 'UUID=523872dd-991a-44a7-a1d4-7050b7646236       /media/SEAGATE  btrfs   defaults,noatime,autodefrag,barrier,datacow        0       3' | tee -a /etc/fstab > /dev/null

#----------------------------------------------------------------------------------------------------------------------------------

# cmdline.txt

  sed -i 's/modules=sd-mod,usb-storage,btrfs quiet rootfstype=btrfs/modules=modules=sd-mod,usb-storage,btrfs,iptables,i2c-dev,fuse,tun quiet rootfstype=btrfs fsck.repair cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1/' /boot/cmdline.txt

#----------------------------------------------------------------------------------------------------------------------------------

# Goodbye

  sudo --user=fabsepi rm -rf Setup_and_configs

  echo
  echo "And you're welcome :))"
  echo
