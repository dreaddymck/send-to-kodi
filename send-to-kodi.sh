#!/usr/bin/env bash

#TODO: Create web application support
#TODO: option in application to change IPTV playlist
# SCRIPTNAME=$(basename "$0")

SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
source "$SEND_TO_KODI_DIR/lib/maintenance"
source "$SEND_TO_KODI_DIR/lib/requirements"
source "$SEND_TO_KODI_DIR/lib/config"
source "$SEND_TO_KODI_DIR/lib/logo"
source "$SEND_TO_KODI_DIR/lib/banner"
source "$SEND_TO_KODI_DIR/lib/about"
source "$SEND_TO_KODI_DIR/lib/server"
source "$SEND_TO_KODI_DIR/lib/dlrz/ytdl-dlrz"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_channels"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_main"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_requests"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_main"
source "$SEND_TO_KODI_DIR/lib/start"

[[ $REMOTE ]] || error "Kodi remote address NOT specified, see --help"
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Invalid download directory, update DOWNLOAD_DIR in $SEND_TO_KODI_CONF."
fi


send_to_kodi_banner

HISTFILE=$HOME/.config/send_to_kodi/.send_to_kodi_history
HISTCONTROL=ignoreboth
shopt -s histappend
kodi_main
