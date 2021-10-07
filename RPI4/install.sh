#!/usr/bin/bash

#!/usr/bin/bash

# Parameters

  identity=""
  identity_command=""

#----------------------------------------------------------------------------------------------------------------------------------

# Doas or sudo

  read -rp "Are you, sir, using either "doas" or "sudo"? " identity
  if [ "$identity" == doas ]; then
    identity_command="doas -u fabsepi"
  elif [ "$identity" == sudo ]; then
    identity_command="sudo --user=fabsepi"
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Preparations

  read -rp "Is script executed as doas bash ./install.sh? Type either yes or no: " pacman
  if [[ "$pacman" == "no" ]]; then
    exit 1
  fi
  read -rp "Type yes to use docker, no to use podman: " docker

#----------------------------------------------------------------------------------------------------------------------------------

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
    apk add docker docker-cli-compose
  elif [[ "$docker" == "no" ]]; then
    apk add podman podman-docker py3-podman podman-remote fuse-overlayfs shadow slirp4netns
  fi
  apk add afetch snapper openssh libressl udisks2 sed man-pages ttf-dejavu cups cups-libs cups-pdf cups-client cups-filters git py3-pip swaybg nautilus bc fnott lz4 cbonsai nerd-fonts haveged gcc make build-base kbd-bkeymaps curl wget i2c-tools lm_sensors perl lsblk e2fsprogs-extra networkmanager iptables tzdata mysql-client firefox mysql pipewire ttf-opensans pipewire-pulse libuser ksysguard libreoffice pavucontrol yambar fuzzel rclone syncthing rsync alacritty terminator fcron unrar unzip zsh zsh-autosuggestions zsh-syntax-highlighting neovim btrfs-progs mousepad ark mpv swappy glances plasma nodejs-current npm lsof zathura zathura-pdf-poppler eudev sway swaylock-effects swayidle figlet mesa-dri-gallium xdg-desktop-portal-wlr xdg-desktop-portal-kde clipman gnome-calculator polkit-gnome pipewire-media-session grim kdialog dialog grep font-awesome swaylockd

#----------------------------------------------------------------------------------------------------------------------------------

# Services

  if [[ "$docker" == "yes" ]]; then
    rc-update add docker default
  elif [[ "$docker" == "no" ]]; then
    rc-update add podman default
    rc-service podman start
    modprobe tun
    usermod --add-subuids 100000-165535 fabsepi
    usermod --add-subgids 100000-165535 fabsepi
    podman system migrate
  fi
  rc-update add swap boot
  rc-update add haveged boot
  for service in fcron syncthing dbus sshd cupsd mariadb fuse iptables networkmanager; do
    rc-update add $service default
  done
  /etc/init.d/iptables save
  /etc/init.d/sshd start
  sed -i -e "/Port 22/s/^#//" /etc/ssh/sshd.config
  sed -i 's/Port 22/Port 1111/' /etc/ssh/sshd.config

#----------------------------------------------------------------------------------------------------------------------------------

# Powerlevel10k-theme

  "$identity_command" mkdir -p /home/fabsepi/.local/share/fonts
  lchsh fabsepi
  lchsh
  "$identity_command" touch /home/fabsepi/.zshrc
  "$identity_command" git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /home/fabsepi/powerlevel10k
  "$identity_command" touch /home/fabsepi/.config/zsh/.zshenv
  "$identity_command" touch /home/fabsepi/.config/zsh/.zshrc
  cat << EOF | "$identity_command" tee -a /home/fabsepi/.zshenv > /dev/null

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:/usr/local/bin"
fi

export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland

export _JAVA_AWT_WM_NONREPARENTING=1

export EDITOR="nvim"
export VISUAL="nvim"

export XDG_SESSION_TYPE=wayland
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export HISTFILE="/home/fabsepi/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

EOF
  cat << EOF | "$identity_command" tee -a /home/fabsepi/.zshrc > /dev/null

autoload -U compinit; compinit
zstyle ':completion::complete:*' gain-privileges 1

exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

_comp_options+=(globdots) # With hidden files

cbonsai -p

bindkey -v
export KEYTIMEOUT=1

source ~/powerlevel10k/powerlevel10k.zsh-theme

alias rm='rm -i'

EOF

#----------------------------------------------------------------------------------------------------------------------------------

# User and groups

  for GRP in spi i2c gpio; do
    addgroup --system $GRP
  done
  for GRP in adm dialout cdrom audio users video games wheel input tty gpio spi i2c plugdev netdev; do
    adduser fabsepi $GRP 
  done
  if [[ "$docker" == "yes" ]]; then
    adduser fabsepi docker
  elif [[ "$docker" == "no" ]]; then
    groupadd docker
    adduser fabsepi docker
  fi
  "$identity_command" chmod u+x /home/fabsepi/Scripts/*
  groupadd sftpusers
  adduser sftpfabse
  adduser sftpfabse sftpusers

#----------------------------------------------------------------------------------------------------------------------------------

# Extra's

  "$identity_command" mv /home/fabsepi/Setup_and_configs/RPI4/Scripts /home/fabsepi
  "$identity_command" mv /home/fabsepi/Setup_and_configs/RPI4/Dockers /home/fabsepi
  "$identity_command" mv /home/fabsepi/Setup_and_configs/RPI4/container_setup.sh /home/fabsepi
  "$identity_command" chmod u+x /home/fabsepi/container_setup.sh
  "$identity_command" mkdir /home/fabsepi/Pro-Fox
  "$identity_command" git clone https://github.com/xmansyx/Pro-Fox.git /home/fabsepi/Pro-Fox
  mkdir /media/SEAGATE
  rm -f /etc/motd
  touch /etc/motd
  mkdir /etc/pipewire
  cp /usr/share/pipewire/pipewire.conf /etc/pipewire/
  sed -i -e "/{ path = "\/usr\/bin\/pipewire-media-session" args = ""/s/^#//" /etc/pipewire/pipewire.conf
  bash -c 'cat > /etc/motd' << EOF
  
Welcome to Alpine Linux - delivered to you by Fabse Inc.!

Proceed with caution, as puns is looming around :D

EOF
  rc-service syncthing start
  "$identity_command" syncthing
  "$identity_command" sed -i 's/127.0.0.1/192.168.0.108/g' /home/fabsepi/.config/syncthing/config.xml

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
  "$identity_command" "$(crontab -l; echo "@reboot /home/fabsepi/Scripts/syncthing.sh")|awk '!x[$0]++'|crontab -)"
  "$identity_command" "$(crontab -l; echo "@reboot /home/fabsepi/Scripts/leon.sh")|awk '!x[$0]++'|crontab -)"
  "$identity_command" "$(crontab -l; echo "@reboot /home/fabsepi/Scripts/etherpad.sh")|awk '!x[$0]++'|crontab -)"
  /bin/bash -c 'echo "@reboot /home/fabsepi/Scripts/seagate.sh" >> /etc/crontab'
  "$identity_command" "$(crontab -l; echo "@reboot /home/fabsepi/Scripts/pipewire.sh")|awk '!x[$0]++'|crontab -)"
  mv /home/fabsepi/Scripts/btrfs_snapshot.sh /etc/cron.daily
  chmod u+x /etc/cron.daily/btrfs_snapshot.sh

#----------------------------------------------------------------------------------------------------------------------------------

# Mariadb (etherpad)

  /etc/init.d/mariadb setup
  rc-service mariadb start
  mysql_secure_installation
  "$identity_command" mysql -u root --password=Alpine54321DB67890Maria -e "CREATE database etherpad_lite_db"
  "$identity_command" mysql -u root --password=Alpine54321DB67890Maria -e "CREATE USER etherpad_fabsepi@localhost identified by 'Ether54321Pad67890FABsePI'"
  "$identity_command" mysql -u root --password=Alpine54321DB67890Maria -e "grant CREATE,ALTER,SELECT,INSERT,UPDATE,DELETE on etherpad_lite_db.* to etherpad_fabsepi@localhost"   
  rc-service mariadb restart

#----------------------------------------------------------------------------------------------------------------------------------

# /etc/fstab

  echo 'UUID=523872dd-991a-44a7-a1d4-7050b7646236       /media/SEAGATE  btrfs   defaults,noatime,autodefrag,barrier,datacow        0       3' | tee -a /etc/fstab > /dev/null

#----------------------------------------------------------------------------------------------------------------------------------

# cmdline.txt

  sed -i 's/modules=sd-mod,usb-storage,btrfs quiet rootfstype=btrfs/modules=modules=sd-mod,usb-storage,btrfs,iptables,i2c-dev,fuse,tun,snd_seq quiet rootfstype=btrfs fsck.repair cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1/' /boot/cmdline.txt

#----------------------------------------------------------------------------------------------------------------------------------

# Goodbye

  "$identity_command" rm -rf Setup_and_configs
  echo
  echo "And you're welcome :))"
  echo
