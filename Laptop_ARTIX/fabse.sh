#!/usr/bin/bash

# Package-installation

  pacman -S artix-archlinux-support

  cp /home/fabse/Konfiguration/Scripts/Installation/Config/pacman.conf /etc/pacman.conf

  pacman -Syu terminator nautilus i3status-rust fzf curl wget gammastep foliate neovim zsh zsh-autosuggestions zsh-syntax-highlighting bashtop spectacle zathura zathura-pdf-poppler pipewire pipewire-alsa pipewire-pulse easyeffects pavucontrol sway swaylock arduino arduino-avr-core openshot mousepad wine wine-mono wine-gecko kicad-library kicad-library-3d links gnome-sudoku gnome-mahjongg gnome-calculator cups-runit dolphin dolphin-plugins qutebrowser geogebra kalzium step neofetch gthumb unrar unzip texlive-most atom libreoffice-fresh ark nodejs rclone syncthing-runit wayland gimp plasma ffmpegthumbs kdegraphics-thumbnailers linux-firmware alsa-utils networkmanager-runit alacritty rsync asp lutris qemu virt-manager libvirt libvirt-python virt-install xdg-desktop-portal-kde xdg-desktop-portal-wlr pipewire-media-session gnuplot python3 python-pip realtime-privileges libva-intel-driver brightnessctl wl-clipboard ld-lsb lsd imv freecad artools iso-profiles aisleriot bsd-games vlc ufw brave-bin obs-studio firefox kicad libpipewire02 polkit-gnome waybar moc fcron-runit steam mypaint slurp grim android-tools qemu-user-static figlet shellcheck kdialog bitwarden jdk-openjdk

#----------------------------------------------------------------------------------------------------------------------------------

# yay-installation

  cp /home/fabse/Konfiguration/Scripts/Installation/Config/makepkg.conf /etc/makepkg.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Files for stm32x

  sudo --user=fabse xdg-open https://www.st.com/en/development-tools/stm32cubeide.html
  sudo --user=fabse xdg-open https://www.st.com/en/development-tools/stm32cubemx.html

  read -rp "Are you ready again? Type anything for yes: " STM32_ready

#----------------------------------------------------------------------------------------------------------------------------------

# Installation of packages from AUR

  yay -S spicetify-cli spotify bastet cbonsai stm32cubeide stm32cubemx openrgb osp-tracker balena-etcher onlyoffice-bin standardnotes-bin revolt-desktop toilet

#----------------------------------------------------------------------------------------------------------------------------------

# ZSH-theme + fonts

  chsh -s /usr/bin/zsh fabse
  chsh -s /usr/bin/zsh root

  sudo --user=fabse git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
  sudo --user=fabse echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' | sudo --user=fabse tee -a /home/fabse/.zshrc > /dev/null

  sudo --user=fabse wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  sudo --user=fabse mv 'MesloLGS NF Regular.ttf' MesloLGS.ttf
  sudo --user=fabse wget https://www.opensans.com/download/open-sans.zip
  sudo --user=fabse unzip open-sans.zip

  sudo --user=fabse mkdir ~/.local/share/fonts
  sudo --user=fabse mv OpenSans-Regular.ttf ~/.local/share/fonts/OpenSans.ttf
  sudo --user=fabse mv MesloLGS.ttf ~/.local/share/fonts/MesloLGS.ttf

  sudo --user=fabse fc-cache -f -v

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

  sudo --user=fabse npm install --save slides-js
  sudo --user=fabse npm install chart.js

#----------------------------------------------------------------------------------------------------------------------------------

# Maple + chemsketch

  sudo --user=fabse xdg-open https://www.acdlabs.com/resources/freeware/chemsketch/download.php

  read -rp "Are you ready again? Type anything for yes: " Science_ready

  sudo --user=fabse unzip /home/fabse/Hentet/ACDLabs202021_ChemSketchFree_Install.zip
  sudo --user=fabse wine /home/fabse/Hentet/ACDLabs202021_ChemSketchFree_Install/setup.exe

#----------------------------------------------------------------------------------------------------------------------------------

# Pulseeffects-presets + pipewire-config
  
  cp /home/fabse/Konfiguration/Scripts/Installation/Config/pipewire.conf /etc/pipewire.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Brave-theme

  sudo --user=fabse xdg-open https://www.deviantart.com/sublime9-design/art/Nord-Theme-for-Chrome-V2-837463227

  read -rp "Are you ready again? Type anything for yes: " Brave_ready

#----------------------------------------------------------------------------------------------------------------------------------

# Firefox-theme

  sudo --user=fabse firefox about:support &

  read -rp "Is the path copied? Then type the full path here: " Firefox_ready

  sudo --user=fabse cp -r /home/fabse/Konfiguration/Scripts/Installation/Config/chrome "$Firefox_ready"
  sudo --user=fabse cp -r /home/fabse/Konfiguration/Scripts/Installation/user.js "$Firefox_ready"

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

  usermod -a -G video,audio,input,power,storage,optical,lp,scanner,dbus,daemon,disk,uucp,vboxusers,realtime,wheel fabse 

  ln -s /etc/runit/sv/cupsd /run/runit/service/ 
  ln -s /etc/runit/sv/syncthing /run/runit/service/
  ln -s /etc/runit/sv/fcron /run/runit/service/
  ln -s /etc/runit/sv/tlp /run/runit/service/                                                                                                                                                   
  ln -s /etc/runit/sv/ufw /run/runit/service/

#----------------------------------------------------------------------------------------------------------------------------------

# Sway-config

  sudo --user=fabse cd /home/fabse || return

  sudo --user=fabse cp -r /home/fabse/Konfiguration/Scripts/Installation/Config/i3status-rust .config
  sudo --user=fabse cp -r /home/fabse/Konfiguration/Scripts/Installation/Config/sway .config
