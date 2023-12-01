#!/bin/bash

SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
# echo "$SEND_TO_KODI_DIR" >&2

source "$SEND_TO_KODI_DIR/lib/source"

[[ $REMOTE ]] || error "Kodi remote address NOT specified, see --help"

HISTFILE=~/.send_to_kodi_history

kodi_main
