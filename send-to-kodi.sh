#!/bin/bash

SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
# echo "$SEND_TO_KODI_DIR" >&2
source "$SEND_TO_KODI_DIR/lib/kodi/show_help"
source "$SEND_TO_KODI_DIR/lib/kodi/error_question_cleanup"
source "$SEND_TO_KODI_DIR/lib/kodi/requests"
source "$SEND_TO_KODI_DIR/lib/kodi/serve"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_main"
source "$SEND_TO_KODI_DIR/lib/kodi/checks"
source "$SEND_TO_KODI_DIR/lib/kodi/defines"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_channels"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_send"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_main"

# IPTV=iptv
# if [[ -f "$SEND_TO_KODI_DIR/$IPTV" ]]; then
#     source "$SEND_TO_KODI_DIR/$IPTV"
# fi

while [[ $* ]]; do
    case "$1" in
    -h | --help)
        show_help
        exit
        ;;
    -s | --stop)
        kodi_stop
        exit
        ;;
    -n | --next)
        kodi_next
        exit
        ;;
    --shutdown)
        kodi_shutdown
        exit
        ;;
    --reboot)
        kodi_reboot
        exit
        ;;
    --iptv)
        iptv
        exit
        ;;
    -d)
        DOWNLOAD_DIR="$2"
        shift
        ;;
    -l)
        SHARE_PORT="$2"
        shift
        ;;
    -r)
        REMOTE="$2"
        shift
        ;;
    -u)
        LOGIN="$2"
        shift
        ;;
    -x) SEND_RAW=1 ;;
    -y) KODI_YOUTUBE=1 ;;
    -g) GUI=1 ;;
    -*) error "Unknown flag: $1" ;;
    *)
        INPUT="$1"
        CYA=1
        ;;
    esac
    shift
done

[[ $REMOTE ]] || error "Kodi remote address NOT specified, see --help"

HISTFILE=~/.send_to_kodi_history

kodi_main
