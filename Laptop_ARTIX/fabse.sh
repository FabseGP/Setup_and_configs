#!/usr/bin/bash

# Package-installation + extra packages

  doas pacman -Syyu kmod libelf git-lfs avahi-runit virtualbox-guest-utils virtualbox-guest-iso cups-filters qemu libvirt-runit virtualbox-host-dkms virtualbox nss-mdns intel-undervolt-runit cups-pdf thermald-runit tlp-runit cpupower-runit pahole cpio perl tar xz bitwarden-cli chrony-runit networkmanager-openvpn xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick terminator noto-fonts-emoji wmctrl libnotify lm_sensors-runit nautilus bc lz4 man-db i3status-rust rust wallutils curl mako wget fzf python-pywal zsh-theme-powerlevel10k go make otf-font-awesome swayidle ttf-opensans gammastep foliate xorg-xlsclients neovim zsh swappy zsh-autosuggestions glances zsh-syntax-highlighting zathura zathura-pdf-poppler pipewire pipewire-alsa pipewire-pulse easyeffects sway arduino arduino-avr-core openshot mousepad wine-staging kicad-library kicad-library-3d links gnome-mahjongg gnome-calculator cups-runit dolphin dolphin-plugins qutebrowser geogebra kalzium step gthumb unrar unzip texlive-most atom libreoffice-fresh ark nodejs rclone syncthing-runit wayland gimp plasma ffmpegthumbs kdegraphics-thumbnailers linux-firmware linux-hardened linux-hardened-headers alsa-utils networkmanager-runit alacritty rsync lutris xdg-desktop-portal-kde xdg-desktop-portal-wlr pipewire-media-session gnuplot python3 python-pip realtime-privileges libva-intel-driver brightnessctl ld-lsb lsd imv freecad artools iso-profiles aisleriot bsd-games mpv iptables-nft nftables-runit ebtables dnsmasq brave-bin obs-studio firefox kicad libpipewire02 polkit-gnome moc steam mypaint grim android-tools figlet shellcheck kdialog bitwarden jdk-openjdk
  pip3 install gdown wheel

#----------------------------------------------------------------------------------------------------------------------------------

# Runit + intel-undervolt + hostname resolution + snapper + virtual machine + tty login prompt + firecfg + git-lfs

  doas ln -s /etc/runit/sv/cupsd /run/runit/service/ 
  doas ln -s /etc/runit/sv/syncthing /run/runit/service/
  doas ln -s /etc/runit/sv/nftables /run/runit/service/
  doas ln -s /etc/runit/sv/lm_sensors /run/runit/service/
  doas ln -s /etc/runit/sv/chrony /run/runit/service/
  doas ln -s /etc/runit/sv/cpupower /run/runit/service/
  doas ln -s /etc/runit/sv/intel-undervolt /run/runit/service/
  doas ln -s /etc/runit/sv/tlp /run/runit/service/
  doas ln -s /etc/runit/sv/thermald /run/runit/service
  doas ln -s /etc/runit/sv/avahi-daemon /run/runit/service
  doas sensors-detect
  doas sv start intel-undervolt
  doas sv start avahi-daemon
  doas cp /home/fabse/Setup_and_configs/Laptop_ARTIX/intel-undervolt.conf /etc/intel-undervolt.conf
  doas intel-undervolt apply
  doas sed -i 's/hosts: files resolve [!UNAVAIL=return] dns/hosts: files mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns/' /etc/nsswitch.conf
  doas usermod -a -G libvirt fabse
  doas usermod -a -G vboxusers fabse
  doas modprobe vboxdrv && modprobe vboxnetadp && modprobe vboxnetflt
  doas firecfg --clean
  doas firecfg
  firecfg --fix
  git-lfs install
  cat << EOF | doas tee -a /etc/issue > /dev/null
This object that you sir are using is property of Fabse Inc. - expect therefore puns! 

EOF
  cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# yay-installation

  doas mv /home/fabse/Setup_and_configs/Laptop_ARTIX/makepkg.conf /etc/makepkg.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Installation of packages from AUR; cnrdrvcups-lb only because of Brother-printer

  doas mkdir -p /home/fabse/Downloads
  cd /home/fabse/Downloads || return
  gdown https://drive.google.com/uc?id=1YBVDSeergaQ7Zx5edMnsbe42ju4pRt3j
  gdown https://drive.google.com/uc?id=1-PD8pP1dnfrmKuOK31XUleTXqokzYfT0
  yay -S stm32cubemx stm32cubeide spicetify-cli-git spotify cnrdrvcups-lb otf-openmoji sunwait-git sway-launcher-desktop swaylock-fancy-git bastet foot freshfetch-git cbonsai nerd-fonts-git fuzzel nudoku clipman openrgb-bin osp-tracker balena-etcher macchina onlyoffice-bin standardnotes-bin revolt-desktop toilet
  rm /home/fabse/Downloads/*
  cd /home/fabse || return 

#----------------------------------------------------------------------------------------------------------------------------------

# ZSH-theme + fonts + ZSH-config (wayland-related)

  doas chsh -s /usr/bin/zsh fabse
  doas chsh -s /usr/bin/zsh root
  touch /home/fabse/.zshenv
  touch /home/fabse/.zshrc
  touch /home/fabse/.zhistory
  cat << EOF | tee -a /home/fabse/.zshenv > /dev/null

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

export HISTFILE="home/fabse/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

EOF
  cat << EOF | tee -a /home/fabse/.zshrc > /dev/null

autoload -U compinit; compinit
zstyle ':completion::complete:*' gain-privileges 1

exit_zsh() { exit }
zle -N exit_zsh
bindkey '^D' exit_zsh

_comp_options+=(globdots) # With hidden files

cbonsai -p

bindkey -v
export KEYTIMEOUT=1

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

alias fabse=macchina
alias rm='rm -i'

EOF
  mkdir ~/.local/share/fonts

#----------------------------------------------------------------------------------------------------------------------------------

# Grub-theme

  git clone https://github.com/vinceliuice/grub2-themes.git
  cd grub2-themes || return
  doas ./install.sh -b -t tela
  cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Reveal.js + chart.js + slides.js

  npm install browserify
  git clone https://github.com/hakimel/reveal.js.git
  cd reveal.js && npm install
  cd /home/fabse || return
  npm install chart.js

#----------------------------------------------------------------------------------------------------------------------------------

# Chemsketch

  gdown https://drive.google.com/uc?id=18_rAJrndm_V0KMfnEA_jGcQfgInObpRC
  mkdir -p /home/fabse/Chemsketch
  unzip -d /home/fabse/Chemsketch /home/fabse/Chemsketch.zip
  rm /home/fabse/Chemsketch.zip
  wine /home/fabse/Chemsketch/setup.exe
  rm -r /home/fabse/Chemsketch

#----------------------------------------------------------------------------------------------------------------------------------

# Pulseeffects-presets + pipewire-config
  
  doas cp /home/fabse/Setup_and_configs/Laptop_ARTIX/pipewire.conf /etc/pipewire.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Firefox-theme

  mkdir -p /home/fabse/firefox/chrome 
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/userChrome.css /home/fabse/firefox/chrome
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/user.js /home/fabse/firefox

#----------------------------------------------------------------------------------------------------------------------------------

# Spicetify

  cd /home/fabse || return
  doas chmod a+wr /opt/spotify
  doas chmod a+wr /opt/spotify/Apps -R
  git clone https://github.com/morpheusthewhite/spicetify-themes.git
  cd spicetify-themes || return
  cp -r -- * ~/.config/spicetify/Themes
  cd "$(dirname "$(spicetify -c)")/Themes/DribbblishDynamic" || return
  mkdir -p ../../Extensions
  cp dribbblish-dynamic.js ../../Extensions/.
  spicetify config extensions dribbblish-dynamic.js
  spicetify config current_theme DribbblishDynamic color_scheme nord-dark
  spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  spicetify backup apply
  cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Sway-related

  cd /home/fabse || return
  mkdir -p .config/{sway,swappy,mako,i3status-rust,alacritty,macchina/ascii}
  mkdir -p .local/share/macchina/themes
  mkdir /home/fabse/Scripts
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_sway .config/sway/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_swappy .config/swappy/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_mako .config/mako/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config.toml .config/i3status-rust/config.toml
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/macchina.toml .config/macchina/macchina.toml
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/Fabse.json .local/share/macchina/themes/Fabse.json
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/fabse.ascii .config/macchina/ascii/fabse.ascii
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/alacritty.yml .config/alacritty/alacritty.yml
  git clone https://github.com/hexive/sunpaper.git
  rm -rf !(images) /home/fabse/sunpaper/*
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/sunpaper.sh /home/fabse/Scripts
  chmod u+x /home/fabse/Scripts/*
  rm -rf /home/fabse/Setup_and_configs
  
