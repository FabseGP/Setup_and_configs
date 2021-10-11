#!/usr/bin/bash

# Parameters

  identity=""
  identity_command=""

#----------------------------------------------------------------------------------------------------------------------------------

# Doas or sudo

  read -rp "Are you, sir, using either \"doas\" or \"sudo\"? " identity
  if [ "$identity" == doas ]; then
    identity_command="doas -u fabse"
  elif [ "$identity" == sudo ]; then
    identity_command="sudo --user=fabse"
  fi

#----------------------------------------------------------------------------------------------------------------------------------

# Package-installation + extra packages

  pacman -Syyu kmod libelf git-lfs avahi-runit virtualbox-guest-utils virtualbox-guest-iso cups-filters qemu libvirt-runit virtualbox-host-dkms virtualbox nss-mdns intel-undervolt-runit cups-pdf thermald-runit tlp-runit cpupower-runit pahole cpio perl tar xz bitwarden-cli chrony-runit networkmanager-openvpn xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick terminator noto-fonts-emoji wmctrl libnotify lm_sensors-runit nautilus bc lz4 man-db i3status-rust rust wallutils curl mako wget fzf python-pywal zsh-theme-powerlevel10k go make otf-font-awesome swayidle ttf-opensans gammastep foliate xorg-xlsclients neovim zsh swappy zsh-autosuggestions glances zsh-syntax-highlighting zathura zathura-pdf-poppler pipewire pipewire-alsa pipewire-pulse easyeffects sway arduino arduino-avr-core openshot mousepad wine-staging kicad-library kicad-library-3d links gnome-mahjongg gnome-calculator cups-runit dolphin dolphin-plugins qutebrowser geogebra kalzium step gthumb unrar unzip texlive-most atom libreoffice-fresh ark nodejs rclone syncthing-runit wayland gimp plasma ffmpegthumbs kdegraphics-thumbnailers linux-firmware linux-hardened linux-hardened-headers alsa-utils networkmanager-runit alacritty rsync lutris xdg-desktop-portal-kde xdg-desktop-portal-wlr pipewire-media-session gnuplot python3 python-pip realtime-privileges libva-intel-driver brightnessctl ld-lsb lsd imv freecad artools iso-profiles aisleriot bsd-games mpv iptables-nft nftables-runit ebtables dnsmasq brave-bin obs-studio firefox kicad libpipewire02 polkit-gnome moc steam mypaint grim android-tools figlet shellcheck kdialog bitwarden jdk-openjdk

#----------------------------------------------------------------------------------------------------------------------------------

# Runit + intel-undervolt + hostname resolution + snapper + virtual machine + tty login prompt + firecfg + git-lfs

  ln -s /etc/runit/sv/cupsd /run/runit/service/ 
  ln -s /etc/runit/sv/syncthing /run/runit/service/
  ln -s /etc/runit/sv/nftables /run/runit/service/
  ln -s /etc/runit/sv/lm_sensors /run/runit/service/
  ln -s /etc/runit/sv/chrony /run/runit/service/
  ln -s /etc/runit/sv/cpupower /run/runit/service/
  ln -s /etc/runit/sv/intel-undervolt /run/runit/service/
  ln -s /etc/runit/sv/tlp /run/runit/service/
  ln -s /etc/runit/sv/thermald /run/runit/service
  ln -s /etc/runit/sv/avahi-daemon /run/runit/service
  sensors-detect
  sv start intel-undervolt
  sv start avahi-daemon
  mv /home/fabse/Setup_and_configs/Laptop_ARTIX/intel-undervolt.conf /etc/intel-undervolt.conf
  intel-undervolt apply
  sed -i 's/hosts: files resolve [!UNAVAIL=return] dns/hosts: files mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] dns/' /etc/nsswitch.conf
  usermod -a -G libvirt fabse
  usermod -a -G vboxusers fabse
  modprobe vboxdrv && modprobe vboxnetadp && modprobe vboxnetflt
  "$identity_command" firecfg --fix
   "$identity_command" git-lfs install
  cat << EOF | tee -a /etc/issue > /dev/null
This object that you sir are using is property of Fabse Inc. - expect therefore puns! 

EOF
  "$identity_command" cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# BTRFS-snapshots; grub-btrfs at shutdown

  cat << EOF | tee -a /etc/rc.shutdown > /dev/null
# Adding BTRFS-snapshots to grub-menu
cd /etc/grub.d
./41_snapshots-btrfs
grub-mkconfig -o /boot/grub/grub.cfg
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# yay-installation

  mv /home/fabse/Setup_and_configs/Laptop_ARTIX/makepkg.conf /etc/makepkg.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Installation of packages from AUR; cnrdrvcups-lb only because of Brother-printer

  mkdir -p /home/fabse/Downloads
  "$identity_command" cd /home/fabse/Downloads || return
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1YBVDSeergaQ7Zx5edMnsbe42ju4pRt3j' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1YBVDSeergaQ7Zx5edMnsbe42ju4pRt3j" -O en.st-stm32cubeide_1.7.0_10852_20210715_0634_amd64.sh_v1.7.0.zip && rm -rf /tmp/cookies.txt
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1-PD8pP1dnfrmKuOK31XUleTXqokzYfT0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1-PD8pP1dnfrmKuOK31XUleTXqokzYfT0" -O en.stm32cubemx-lin_v6-3-0_v6.3.0.zip && rm -rf /tmp/cookies.txt
  yay -S stm32cubemx stm32cubeide spicetify-cli-git spotify cnrdrvcups-lb otf-openmoji sunwait-git sway-launcher-desktop swaylock-fancy-git bastet foot freshfetch-git cbonsai nerd-fonts-git fuzzel nudoku clipman openrgb-bin osp-tracker balena-etcher macchina onlyoffice-bin standardnotes-bin revolt-desktop toilet
  rm /home/fabse/Downloads/*
  "$identity_command" cd /home/fabse || return 

#----------------------------------------------------------------------------------------------------------------------------------

# ZSH-theme + fonts + ZSH-config (wayland-related)

  chsh -s /usr/bin/zsh fabse
  chsh -s /usr/bin/zsh root
  "$identity_command" touch /home/fabse/.zshenv
  "$identity_command" touch /home/fabse/.zshrc
  "$identity_command" touch /home/fabse/.zhistory
  cat << EOF | "$identity_command" tee -a /home/fabse/.zshenv > /dev/null

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
  cat << EOF | "$identity_command" tee -a /home/fabse/.zshrc > /dev/null

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
  "$identity_command" mkdir ~/.local/share/fonts

#----------------------------------------------------------------------------------------------------------------------------------

# Grub-theme

  "$identity_command" git clone https://github.com/vinceliuice/grub2-themes.git
  "$identity_command" cd grub2-themes || return
  ./install.sh -b -t tela
  "$identity_command" cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Reveal.js + chart.js + slides.js

  "$identity_command" npm install browserify
  "$identity_command" git clone https://github.com/hakimel/reveal.js.git
  "$identity_command" cd reveal.js && npm install
  "$identity_command" cd /home/fabse || return
  "$identity_command" npm install chart.js

#----------------------------------------------------------------------------------------------------------------------------------

# Chemsketch

  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=18_rAJrndm_V0KMfnEA_jGcQfgInObpRC' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=18_rAJrndm_V0KMfnEA_jGcQfgInObpRC" -O Chemsketch.zip && rm -rf /tmp/cookies.txt
  "$identity_command" mkdir -p /home/fabse/Chemsketch
  "$identity_command" unzip -d /home/fabse/Chemsketch /home/fabse/Chemsketch.zip
  "$identity_command" rm /home/fabse/Chemsketch.zip
  "$identity_command" wine /home/fabse/Chemsketch/setup.exe
  "$identity_command" rm -r /home/fabse/Chemsketch

#----------------------------------------------------------------------------------------------------------------------------------

# Pulseeffects-presets + pipewire-config
  
  cp /home/fabse/Setup_and_configs/Laptop_ARTIX/pipewire.conf /etc/pipewire.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Firefox-theme

  "$identity_command" mkdir -p /home/fabse/firefox/chrome 
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/userChrome.css /home/fabse/firefox/chrome
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/user.js /home/fabse/firefox

#----------------------------------------------------------------------------------------------------------------------------------

# Spicetify

  "$identity_command" cd /home/fabse || return
  chmod a+wr /opt/spotify
  chmod a+wr /opt/spotify/Apps -R
  "$identity_command" git clone https://github.com/morpheusthewhite/spicetify-themes.git
  "$identity_command" cd spicetify-themes || return
  "$identity_command" cp -r -- * ~/.config/spicetify/Themes
  "$identity_command" cd "$(dirname "$(spicetify -c)")/Themes/DribbblishDynamic" || return
  "$identity_command" mkdir -p ../../Extensions
  "$identity_command" cp dribbblish-dynamic.js ../../Extensions/.
  "$identity_command" spicetify config extensions dribbblish-dynamic.js
  "$identity_command" spicetify config current_theme DribbblishDynamic color_scheme nord-dark
  "$identity_command" spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  "$identity_command" spicetify backup apply
  "$identity_command" cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Sway-related

  "$identity_command" cd /home/fabse || return
  "$identity_command" mkdir -p .config/{sway,swappy,mako,i3status-rust,alacritty,macchina/ascii}
  "$identity_command" mkdir -p .local/share/macchina/themes
  "$identity_command" mkdir /home/fabse/Scripts
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_sway .config/sway/config
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_swappy .config/swappy/config
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_mako .config/mako/config
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config.toml .config/i3status-rust/config.toml
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/macchina.toml .config/macchina/macchina.toml
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/Fabse.json .local/share/macchina/themes/Fabse.json
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/fabse.ascii .config/macchina/ascii/fabse.ascii
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/alacritty.yml .config/alacritty/alacritty.yml
  "$identity_command" git clone https://github.com/hexive/sunpaper.git
  "$identity_command" rm -rf !(images) /home/fabse/sunpaper/*
  "$identity_command" mv -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/sunpaper.sh /home/fabse/Scripts
  "$identity_command" chmod u+x /home/fabse/Scripts/*
  "$identity_command" rm -rf /home/fabse/Setup_and_configs
  
