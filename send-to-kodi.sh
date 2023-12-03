#!/usr/bin/env bash

#TODO: create editable collection of send raw domains and/or command flag for soundcloud like links.
#TODO: Debug application not working with Android Termux
#TODO: Remove Zenity support
#TODO: Create web application support
#TODO: option in application to change IPTV playlist

SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
# echo "$SEND_TO_KODI_DIR" >&2

source "$SEND_TO_KODI_DIR/lib/requirements"
source "$SEND_TO_KODI_DIR/lib/config"
source "$SEND_TO_KODI_DIR/lib/about"
source "$SEND_TO_KODI_DIR/lib/maintenance"
source "$SEND_TO_KODI_DIR/lib/server"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_channels"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_main"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_requests"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_main"
source "$SEND_TO_KODI_DIR/lib/start"

[[ $REMOTE ]] || error "Kodi remote address NOT specified, see --help"

HISTFILE=$HOME/.config/send_to_kodi/.send_to_kodi_history
HISTCONTROL=ignoreboth
shopt -s histappend
set -o history 
kodi_main
