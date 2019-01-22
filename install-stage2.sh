#!/usr/bin/env sh

set -e

# TODO: check whether we are in X before running

printf %s\\n "installing wallpaper..."
# TODO: autodetect monitor dimensions and link appropriate size
ln -sfv "${PWD}/wallpaper-1440x900.png" "${HOME}/wallpaper.png"

printf %s\\n "installing slock + pm-utils..."
sudo apk add slock pm-utils
rc-update add acpid
sudo sh -c 'printf \\n%s\\n "%sudo ALL=(ALL) NOPASSWD:/usr/sbin/pm-suspend" >> /etc/sudoers'
# TODO physlock instead of slock, currently 0.5 in the testing repos is too old and doesn't work (utmp issues  https://bugs.alpinelinux.org/issues/3282)

TMP="$(mktemp -d)"
trap "rm -rf ${TMP}" INT TERM QUIT

printf %s\\n "installing tewi..."

sudo apk add make bdftopcf mkfontdir mkfontscale xset fontconfig

cp -r vendor/tewi-font "$TMP"
cd "${TMP}/tewi-font"
make
mkdir -p "${HOME}/.local/share/fonts"
mv -v out "${HOME}/.local/share/fonts/tewi"
cd -

xset +fp "${HOME}/.local/share/fonts/tewi"  # x11 lfd, this is also done in .xinit
fc-cache -fv  # fontconfig

sudo apk del bdftopcf
