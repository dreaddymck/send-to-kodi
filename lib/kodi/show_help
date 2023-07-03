#!/bin/bash

show_help() {
    cat <<EOF >&2
Usage: send-to-kodi.sh [options] -r HOST:PORT [URL|FILE]

Send a local or online video to Kodi. Run without URL to get a GUI.
In the GUI, you may prepend an URL with ! to disable resolving (like -x).

Options:
  -d DIRECTORY           Temporary download directory for high quality streaming
  -l PORT                Local port number used for file sharing (default 8080)
  -r HOST:PORT           Kodi remote address
  -u USERNAME:PASSWORD   Kodi login credentials
  -x                     Do not try to resolve URL, just send it
  -y                     Use Kodi's youtube addon instead of youtube-dl

  -s|--stop              stop kodi playback
  -n|--next              next kodi playback
  --active               display Kodi active playlist id
  --iptv                 load iptv interface
  -g                     enable zenity gui (default disabled)

Commands:
  stop                   stop kodi playback
  next                   next kodi playback
  active                 display Kodi active playlist id
  iptv                   load iptv interface    

Settings override:       ~/.sendtokodi 

Environment variables:
  TWISTED_PATH           Path to python-twisted webserver

Dependencies:
  jq                     JSON Processing
  youtube-dl or yt-dlp   Support for hunderds of sites
  python-twisted         Local media sharing and high quality downloads
  zenity                 Graphical interface (optional)
  PhantomJS              Scriptable Headless Browser (optional)
EOF
}