#!/usr/bin/env sh

set -e

sudo sed -i 's/#//g' /etc/apk/repositories
sudo apk update

printf %s\\n "installing mksh as login shell..."
sudo apk add mksh
printf %s\\n "you'll be prompted for your password to chsh"
sudo chsh -s "$(command -v mksh)" "$(whoami)"

printf %s\\n "installing core graphical software..."
sudo setup-xorg-base
# freetype-dev is required to fix libharfbuzz dynamic symbol issues when running dunst
# tatami-bar requires xprop, xrdb, and wireless-tools (iwgetid)
sudo apk add \
    bspwm sxhkd rxvt-unicode dmenu stalonetray dunst libnotify feh freetype-dev \
    lemonbar scrot xclip xinit xhost xprop xrdb wireless-tools

# todo: s/scrot/maim

printf %s\\n "installing dotfiles..."
sudo apk add git stow
git clone --recursive https://github.com/JoshuaRLi/dotfiles "${HOME}/dotfiles"
cd "${HOME}/dotfiles"
sh ./link.sh tatami
