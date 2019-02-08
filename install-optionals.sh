#!/usr/bin/env sh

set -e

printf %s\\n "setting up audio (ALSA -> hw)..."
sudo apk add alsa-utils alsaconf
sudo rc-update add alsa
sudo rc-service alsa start
sudo addgroup $USER audio
# hardcoded .asoundrc for direct alsa -> hw, works for most cases
# change default card or add more profiles (cat /proc/asound/cards)
cat << EOF > "${HOME}/.asoundrc"
pcm.!default {
    type hw
    card 0
}
ctl.!default {
    type hw
    card 0
}
EOF
sudo amixer sset Master unmute

printf %s\\n "installing busybox replacements..."
grep less shadow util-linux wget pciutils usbutils coreutils binutils findutils

printf %s\\n "installing other useful software..."
sudo apk add \
    atool cryptsetup curl gnupg htop nano ncdu openssh-client tree \
    mplayer mpv sxiv editorconfig micro firefox ttf-dejavu

printf %s\\n "installing udevil + pmount..."
sudo apk add udevil
# TODO: pmount

printf %s\\n "installing python3 + pip..."
sudo apk add python3
python3 -m ensurepip
pip3 install --upgrade pip --user
sudo ln -sfv /usr/bin/python3 /usr/bin/python
sudo ln -sfv /usr/bin/pip3 /usr/bin/pip
