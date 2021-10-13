#!/usr/bin/bash

# Correct start

  read -rp "Is the script executed as bash -i /script/path? Is alias yay=paru added to .bashrc? " hello
  doas rm -rf /install_script
  
#----------------------------------------------------------------------------------------------------------------------------------

# Package-installation + default java; plasma = ^1 ^2 ^3 ^4 ^26 ^29 ^38 ^39 ^43 ^44 
  
  doas pacman -Syyu kmod libelf qt5-wayland clang qt6-wayland avogadrolibs sagemath seatd ttf-iosevka-nerd arm-none-eabi-gcc gdb openocd arm-none-eabi-gdb libopencm3 vulkan-intel lib32-vulkan-intel phonon-qt5-vlc dialog avahi-runit virtualbox-guest-utils virtualbox-guest-iso cups-filters qemu libvirt-runit virtualbox-host-dkms virtualbox nss-mdns intel-undervolt-runit cups-pdf thermald-runit tlp-runit cpupower-runit pahole cpio perl tar xz bitwarden-cli networkmanager-openvpn xmlto python-sphinx python-sphinx_rtd_theme graphviz imagemagick terminator noto-fonts-emoji wmctrl libnotify lm_sensors-runit pcmanfm-gtk3 gvfs man-db i3status-rust rust wallutils curl mako wget fzf python-pywal zsh-theme-powerlevel10k go make otf-font-awesome swayidle ttf-opensans gammastep foliate xorg-xlsclients zsh swappy zsh-autosuggestions glances zsh-syntax-highlighting zathura zathura-pdf-mupdf pipewire pipewire-alsa pipewire-pulse easyeffects sway arduino-avr-core openshot mousepad wine-staging links gnome-mahjongg gnome-calculator cups-runit qutebrowser geogebra kalzium step gthumb unrar unzip texlive-most atom libreoffice-fresh nodejs rclone syncthing-runit wayland gimp ffmpegthumbs linux-hardened linux-hardened-headers alsa-utils alacritty rsync lutris xdg-desktop-portal-kde xdg-desktop-portal-wlr pipewire-media-session gnuplot python3 python-pip libva-intel-driver brightnessctl ld-lsb lsd imv freecad artools iso-profiles aisleriot bsd-games mpv iptables-nft nftables-runit ebtables dnsmasq brave-bin obs-studio librewolf libpipewire02 polkit-gnome moc mypaint grim android-tools figlet shellcheck jdk-openjdk meson gvfs-mtp tumbler xarchiver
  
#----------------------------------------------------------------------------------------------------------------------------------

# Installation of packages from AUR; cnrdrvcups-lb only because of Canon-printer

  doas cp /home/fabse/Setup_and_configs/Laptop_ARTIX/makepkg.conf /etc/makepkg.conf
  mkdir -p /home/fabse/Downloads
  yay -S stm32cubemx spicetify-cli wayfire-desktop-git avogadroapp bibata-rainbow-cursor-theme handlr-bin candy-icons-git tela-icon-theme sweet-gtk-theme-dark spotify bibata-rainbow-cursor-theme cnrdrvcups-lb kicad-nightly-bin kicad-library-nightly kicad-library-3d-nightly otf-openmoji sunwait-git arduino-ide-beta-bin sway-launcher-desktop swaylock-fancy-git bastet freshfetch-bin cbonsai fuzzel nudoku clipman openrgb-bin osp-tracker macchina onlyoffice-bin standardnotes-bin revolt-desktop toilet
  yay -Scd
  doas archlinux-java set java-17-openjdk
  cd /home/fabse || return 

#----------------------------------------------------------------------------------------------------------------------------------

# Runit + intel-undervolt + hostname resolution + snapper + virtual machine + tty login prompt + firecfg + git-lfs

  doas ln -s /etc/runit/sv/cupsd /run/runit/service/ 
  doas ln -s /etc/runit/sv/syncthing /run/runit/service/
  doas ln -s /etc/runit/sv/nftables /run/runit/service/
  doas ln -s /etc/runit/sv/lm_sensors /run/runit/service/
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
  doas usermod -a -G games fabse
  doas modprobe vboxdrv && doas modprobe vboxnetadp && doas modprobe vboxnetflt
  cat << EOF | doas tee -a /etc/issue > /dev/null
This object that you sir are using is property of Fabse Inc. - expect therefore puns! 

EOF
  cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Default apps + config

  handlr add .pdf org.pwmt.zathura.desktop
  handlr add .png imv.desktop
  handlr add .jpeg img.desktop
  mkdir -p /home/fabse/.config/zathura
  touch /home/fabse/.config/zathura/zathurarc
  cat << EOF | doas tee -a /home/fabse/.config/zathura/zathurarc > /dev/null

# Copy to clipboard
  set selection-clipboard clipboard
  
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# ZSH-theme + fonts + ZSH-config (wayland-related)

  doas chsh -s /usr/bin/zsh fabse
  doas chsh -s /usr/bin/zsh root
  touch /home/fabse/.zshenv
  touch /home/fabse/.zshrc
  touch /home/fabse/.zhistory
  touch /home/fabse/.gtk-bookmarks
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
export QT_QPA_PLATFORM=wayland
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

alias fabse="macchina"
alias rm="rm -i"
alias yay="paru"

EOF
cat << EOF | tee -a /etc/environment > /dev/null

# By Fabse
export MOZ_ENABLE_WAYLAND=1
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export EDITOR="nvim"
export VISUAL="nvim"
export XDG_SESSION_TYPE=wayland
export QT_QPA_PLATFORM=wayland
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export HISTFILE="home/fabse/.zhistory"    # History filepath
export HISTSIZE=10000                   # Maximum events for internal history
export SAVEHIST=10000                   # Maximum events in history file

EOF
  mkdir ~/.local/share/fonts
  touch /home/fabse/.config/electron-flags.conf
  touch /home/fabse/.config/brave-flags.conf
  cat << EOF | tee -a /home/fabse/.config/electron-flags.conf > /dev/null

# Wayland-support
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOF
cat << EOF | tee -a /home/fabse/.config/brave-flags.conf > /dev/null

# Wayland-support
--enable-features=UseOzonePlatform
--ozone-platform=wayland
EOF

#----------------------------------------------------------------------------------------------------------------------------------

# Grub-theme

  git clone https://github.com/vinceliuice/grub2-themes.git
  cd grub2-themes || return
  doas ./install.sh -b -t tela
  cd /home/fabse || return
  rm -rf /home/fabse/grub2-themes

#----------------------------------------------------------------------------------------------------------------------------------

# Reveal.js + chart.js + slides.js

  mkdir -p /home/fabse/npm_modules/{browserify,chart_js}
  cd /home/fabse/npm_modules/chart_js || return
  npm install chart.js
  npm audit fix
  cd /home/fabse/npm_modules/browserify || return
  npm install browserify
  npm audit fix
  cd /home/fabse/npm_modules || return
  git clone https://github.com/hakimel/reveal.js.git
  cd reveal.js && npm install
  npm audit fix
  cd /home/fabse || return
 

#----------------------------------------------------------------------------------------------------------------------------------

# Pulseeffects-presets + pipewire-config
  
  doas cp /home/fabse/Setup_and_configs/Laptop_ARTIX/pipewire.conf /etc/pipewire.conf

#----------------------------------------------------------------------------------------------------------------------------------

# Firefox-theme

  mkdir -p /home/fabse/firefox/chrome 
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/firefox/* /home/fabse/firefox
  mv /home/fabse/firefox/userChrome.css /home/fabse/firefox/chrome
  touch /home/fabse/.librewolf/librewolf.overrides.cfg
  echo "lockPref("identity.fxaccounts.enabled",true);" >> /home/fabse/.librewolf/librewolf.overrides.cfg

#----------------------------------------------------------------------------------------------------------------------------------

# Spicetify

  cd /home/fabse || return
  doas chmod a+wr /opt/spotify
  doas chmod a+wr /opt/spotify/Apps -R
  git clone https://github.com/morpheusthewhite/spicetify-themes.git
  cd spicetify-themes || return
  cp -r -- * ~/.config/spicetify/Themes
  cd "$(dirname "$(spicetify -c)")/Themes/Dribbblish"
  mkdir -p ../../Extensions
  cp dribbblish.js ../../Extensions/.
  spicetify config extensions dribbblish.js
  spicetify config current_theme Dribbblish color_scheme nord-dark
  spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
  spicetify backup apply
  cd /home/fabse || return

#----------------------------------------------------------------------------------------------------------------------------------

# Sway-related

  cd /home/fabse || return
  mkdir -p .config/{sway,swappy,mako,i3status-rust,alacritty,macchina/ascii}
  mkdir -p .local/share/macchina/themes
  mkdir /home/fabse/Scripts
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config .config/sway/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_swappy .config/swappy/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config_mako .config/mako/config
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/config.toml .config/i3status-rust/config.toml
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/macchina.toml .config/macchina/macchina.toml
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/Fabse.json .local/share/macchina/themes/Fabse.json
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/fabse.ascii .config/macchina/ascii/fabse.ascii
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/alacritty.yml .config/alacritty/alacritty.yml
  git clone https://github.com/hexive/sunpaper.git
  rm -rf /home/fabse/sunpaper/{extra,.git,README.md,screenshots}
  cp -r /home/fabse/Setup_and_configs/Laptop_ARTIX/sway/sunpaper.sh /home/fabse/Scripts
  chmod u+x /home/fabse/Scripts/*
  cd /home/fabse || return
