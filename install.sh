#!/usr/bin/env sh

set -e

# enable all repositories that are commented out (this will be install version and edge)
sudo sed -i 's/#//g' /etc/apk/repositories
sudo apk update

printf %s\\n "installing mksh as login shell..."
sudo apk add mksh
printf %s\\n "you'll be prompted for your password to chsh"
sudo chsh -s "$(command -v mksh)" "$(whoami)"

printf %s\\n "installing core graphical software..."
sudo setup-xorg-base
# freetype-dev is required to fix libharfbuzz dynamic symbol issues when running dunst
# something needs dbus-x11, too lazy to figure out what
# tatami-bar requires procps, xprop, xrdb, and wireless-tools (iwgetid)
sudo apk add \
    bspwm sxhkd rxvt-unicode dmenu stalonetray dunst libnotify feh freetype-dev \
    lemonbar scrot xclip xinit xhost dbus-x11 \
    procps xprop xrdb wireless-tools

# todo: s/scrot/maim

printf %s\\n "installing wallpaper..."
# manually put your screen dimensions in here, otherwise i'd need an install-stage2.sh to do in X
ln -sfv "${PWD}/wallpaper-1440x900.png" "${HOME}/wallpaper.png"

printf %s\\n "installing slock + pm-utils..."
sudo apk add slock pm-utils
rc-update add acpid
sudo sh -c 'printf \\n%s\\n "%sudo ALL=(ALL) NOPASSWD:/usr/sbin/pm-suspend" >> /etc/sudoers'
# TODO physlock instead of slock, currently 0.5 in the testing repos is too old and doesn't work (utmp issues  https://bugs.alpinelinux.org/issues/3282)

printf %s\\n "installing tewi..."
TMP="$(mktemp -d)"
trap "rm -rf ${TMP}" INT TERM QUIT
sudo apk add make bdftopcf mkfontdir mkfontscale xset fontconfig
cp -r vendor/tewi-font "$TMP"
cd "${TMP}/tewi-font"
make
mkdir -p "${HOME}/.local/share/fonts"
mv -v out "${HOME}/.local/share/fonts/tewi"
cd -
fc-cache -fv  # fontconfig. xset for x11 lfd is done in .xinitrc
sudo apk del bdftopcf

printf %s\\n "installing dotfiles..."
sudo apk add git stow
git clone --recursive https://github.com/JoshuaRLi/dotfiles "${HOME}/dotfiles"
cd "${HOME}/dotfiles"
sh ./link.sh tatami
