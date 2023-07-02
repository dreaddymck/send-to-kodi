#!/bin/bash

# settings
GUI=0
DOWNLOAD_DIR=.
KODI_YOUTUBE=0
SEND_RAW=0
SHARE_PORT=8080
REMOTE=""
LOGIN=""
HOST_NAME=""
HEIGHT=""
# settings override
if [[ -f "~/.sendtokodi" ]]; then
    source "~/.sendtokodi"
fi
CYA=""