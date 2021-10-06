#!/usr/bin/bash

# Package-installation

  cp /home/fabse/Setup_and_configs/Laptop_ARTIX/pacman.conf /etc/pacman.conf

  pacman -Sy --noconfirm archlinux-keyring artix-keyring
  pacman-key --init
  pacman-key --populate archlinux artix
  pacman -Scc

  pacman -Syyu kmod libelf pahole cpio perl tar xz bitwarden-cli networkmanager-openvpn xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick terminator noto-fonts-emoji wmctrl libnotify lm_sensors-runit nautilus bc lz4 man-db i3status-rust rust wallutils curl mako wget fzf python-pywal zsh-theme-powerlevel10k go make otf-font-awesome swayidle ttf-opensans gammastep foliate xorg-xlsclients neovim zsh swappy zsh-autosuggestions glances zsh-syntax-highlighting zathura zathura-pdf-poppler pipewire pipewire-alsa pipewire-pulse easyeffects sway arduino arduino-avr-core openshot mousepad wine-staging kicad-library kicad-library-3d links gnome-mahjongg gnome-calculator cups-runit dolphin dolphin-plugins qutebrowser geogebra kalzium step gthumb unrar unzip texlive-most atom libreoffice-fresh ark nodejs rclone syncthing-runit wayland gimp plasma ffmpegthumbs kdegraphics-thumbnailers linux-firmware alsa-utils networkmanager-runit alacritty rsync lutris xdg-desktop-portal-kde xdg-desktop-portal-wlr pipewire-media-session gnuplot python3 python-pip realtime-privileges libva-intel-driver brightnessctl ld-lsb lsd imv freecad artools iso-profiles aisleriot bsd-games mpv iptables-runit brave-bin obs-studio firefox kicad libpipewire02 polkit-gnome moc fcron-runit steam mypaint grim android-tools qemu figlet shellcheck kdialog bitwarden jdk-openjdk

#----------------------------------------------------------------------------------------------------------------------------------

# yay-installation

  cp /home/fabse/Setup_and_configs/Laptop_ARTIX/makepkg.conf /etc/makepkg.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Files for stm32x

  sudo --user=fabse xdg-open https://www.st.com/en/development-tools/stm32cubeide.html
  sudo --user=fabse xdg-open https://www.st.com/en/development-tools/stm32cubemx.html

  read -rp "Are you ready again? Type anything for yes: " STM32_ready

#----------------------------------------------------------------------------------------------------------------------------------

# Installation of packages from AUR

  yay -S spicetify-cli-git spotify otf-openmoji sunwait-git sway-launcher-desktop swaylock-fancy-git bastet foot freshfetch-git cbonsai nerd-fonts-git stm32cubeide fuzzel nudoku clipman stm32cubemx openrgb-bin osp-tracker balena-etcher macchina onlyoffice-bin standardnotes-bin revolt-desktop toilet

#----------------------------------------------------------------------------------------------------------------------------------

# ZSH-theme + fonts + ZSH-config (wayland-related)

  chsh -s /usr/bin/zsh fabse
  chsh -s /usr/bin/zsh root

  sudo --user=fabse touch /home/fabse/.zshenv
  sudo --user=fabse touch /home/fabse/.zshrc
  sudo --user=fabse touch /home/fabse/.zhistory

  cat << EOF | sudo --user=fabse tee -a /home/fabse/.zshenv > /dev/null

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
export XDG_CACHE_HOME="$XDG_CONFIG_HOME/.cache"

export HISTFILE="home/fabse/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

EOF

  cat << EOF | sudo --user=fabse tee -a /home/fabse/.zshrc > /dev/null

autoload -U compinit; compinit

_comp_options+=(globdots) # With hidden files

cbonsai -p

bindkey -v
export KEYTIMEOUT=1

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

alias fabse=macchina

EOF

  sudo --user=fabse mkdir ~/.local/share/fonts

#----------------------------------------------------------------------------------------------------------------------------------

# Grub-theme

  sudo --user=fabse git clone https://github.com/vinceliuice/grub2-themes.git
  sudo --user=fabse cd grub2-themes || return

  ./install.sh -b -t tela
  sudo --user=fabse cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Reveal.js + chart.js + slides.js

  sudo --user=fabse npm install browserify

  sudo --user=fabse git clone https://github.com/hakimel/reveal.js.git
  sudo --user=fabse cd reveal.js && npm install

  sudo --user=fabse cd /home/fabse || return

  sudo --user=fabse npm install chart.js

#----------------------------------------------------------------------------------------------------------------------------------

# Maple + chemsketch

  sudo --user=fabse xdg-open https://www.acdlabs.com/resources/freeware/chemsketch/download.php

  read -rp "Are you ready again? Type anything for yes: " Science_ready

  sudo --user=fabse unzip /home/fabse/Hentet/ACDLabs202021_ChemSketchFree_Install.zip
  sudo --user=fabse wine /home/fabse/Hentet/ACDLabs202021_ChemSketchFree_Install/setup.exe

#----------------------------------------------------------------------------------------------------------------------------------

# Pulseeffects-presets + pipewire-config
  
  cp /home/fabse/Setup_and_configs/Laptop_ARTIX/pipewire.conf /etc/pipewire.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Firefox-theme

  sudo --user=fabse firefox about:support &

  read -rp "Is the path copied? Then type the full path here: " Firefox_ready

  sudo --user=fabse mkdir "$Firefox_ready"/chrome

  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/userChrome.css "$Firefox_ready"/chrome
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/user.js "$Firefox_ready"

#----------------------------------------------------------------------------------------------------------------------------------

# Spicetify

  sudo --user=fabse spotify

  sudo --user=fabse read -rp "Are you ready again? Type anything for yes: " Spotify_ready

  chmod a+wr /opt/spotify
  chmod a+wr /opt/spotify/Apps -R

  sudo --user=fabse git clone https://github.com/morpheusthewhite/spicetify-themes.git
  sudo --user=fabse cd spicetify-themes || return
  sudo --user=fabse cp -r -- * ~/.config/spicetify/Themes

  sudo --user=fabse cd "$(dirname "$(spicetify -c)")/Themes/DribbblishDynamic" || return
  sudo --user=fabse mkdir -p ../../Extensions
  sudo --user=fabse cp dribbblish-dynamic.js ../../Extensions/.
  sudo --user=fabse spicetify config extensions dribbblish-dynamic.js
  sudo --user=fabse spicetify config current_theme DribbblishDynamic color_scheme nord-dark
  sudo --user=fabse spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  sudo --user=fabse spicetify backup apply

  sudo --user=fabse cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# User groups + Runit

  ln -s /etc/runit/sv/cupsd /run/runit/service/ 
  ln -s /etc/runit/sv/syncthing /run/runit/service/
  ln -s /etc/runit/sv/fcron /run/runit/service/
  ln -s /etc/runit/sv/iptables /run/runit/service/
  ln -s /etc/runit/sv/lm_sensors /run/runit/service/

  sensors-detect

#----------------------------------------------------------------------------------------------------------------------------------

# Sway-related

  sudo --user=fabse cd /home/fabse || return
  
  sudo --user=fabse mkdir -p .config/{sway,swappy,mako,i3status-rust,alacritty,macchina/ascii}
  sudo --user=fabse mkdir -p .local/share/macchina/themes
  sudo --user=fabse mkdir /home/fabse/Scripts

  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_sway .config/sway/config
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_swappy .config/swappy/config
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_mako .config/mako/config
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config.toml .config/i3status-rust/config.toml
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/macchina.toml .config/macchina/macchina.toml
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/Fabse.json .local/share/macchina/themes/Fabse.json
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/fabse.ascii .config/macchina/ascii/fabse.ascii
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/alacritty.yml .config/alacritty/alacritty.yml

  sudo --user=fabse git clone https://github.com/hexive/sunpaper.git
  sudo --user=fabse rm -rf !(images) /home/fabse/sunpaper/*
  sudo --user=fabse cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/sunpaper.sh /home/fabse/Scripts
  sudo --user=fabse chmod u+x /home/fabse/Scripts/*
