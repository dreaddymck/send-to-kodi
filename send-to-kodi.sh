#!/bin/bash

SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
echo "$SEND_TO_KODI_DIR" >&2
source "$SEND_TO_KODI_DIR/lib/show_help.sh"
source "$SEND_TO_KODI_DIR/lib/error_question_cleanup.sh"
source "$SEND_TO_KODI_DIR/lib/requests.sh"
source "$SEND_TO_KODI_DIR/lib/serve.sh"
source "$SEND_TO_KODI_DIR/lib/kodi_main.sh"
source "$SEND_TO_KODI_DIR/lib/checks.sh"
source "$SEND_TO_KODI_DIR/lib/defines.sh"

# SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
# echo "$SEND_TO_KODI_DIR"
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
