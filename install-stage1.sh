#!/usr/bin/env sh

set -e

# TODO: detect and fail on presence of something like /media/sdb/ from install
sudo sed -i 's/#//g' /etc/apk/repositories
sudo apk update

printf %s\\n "installing mksh as login shell..."
sudo apk add mksh
printf %s\\n "you'll be prompted for your password to chsh"
sudo chsh -s "$(which mksh)" "$(whoami)"

printf %s\\n "installing core graphical software..."
sudo setup-xorg-base
# freetype-dev is required to fix libharfbuzz dynamic symbol issues when running dunst
sudo apk add \
    bspwm sxhkd rxvt-unicode dmenu stalonetray dunst libnotify feh freetype-dev \
    lemonbar dbus-x11 scrot xclip xf86-input-synaptics xinit xhost xprop xrdb

printf %s\\n "installing (uf)etch..."
mkdir -p "${HOME}/bin"
# custom ufetch, depends on non-busybox ps for the -p flag
sudo apk add procps
wget https://raw.githubusercontent.com/JoshuaRLi/tatami/master/ufetch -O "${HOME}/bin/uf"
chmod u+x "${HOME}/bin/uf"

printf %s\\n "installing dotfiles..."
sudo apk add git stow
git clone --recursive https://github.com/JoshuaRLi/dotfiles "${HOME}/dotfiles"
cd "${HOME}/dotfiles"
sh ./link.sh tatami
