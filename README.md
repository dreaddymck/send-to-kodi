# Send to Kodi DMCK

Two projects combined.

* https://github.com/allejok96/send-to-kodi
* https://github.com/shahin8r/iptv

Offering the following features

* Send compatible yt-dlp/youtube-dl streams to Kodi.
* Send compatible local media to Kodi.
* MPEG-DASH (high quality video) support.
* IPTV m3u playlist interface, send iptv to kodi (__Work In Progress__)
* Zenity input interface

*Note: Kodi add-ons may be required for proprietory media streams.*

## Installation

1. In Kodi, enable *System > Servicies > Web server > Allow remote control via HTTP*.

1. Install on your Kodi box:
   * `InputStream.Adaptive` to enable MPEG-DASH support.
   * *Youtube add-on* for better youtube support.

1. Install on your Linux machine:
   * `yt-dlp`           to add support for hundreds of video sites.
   * `jq`               JSON Processing
   * `fzf`              required for iptv interface (optional) - https://github.com/junegunn/fzf
   * `python-twisted`   to enable local file sharing and MPEG-DASH support (optional).
   * `zenity`           Graphical interface (optional)
   * `PhantomJS`        Scriptable Headless Browser (optional)

1. Environment variables: TWISTED_PATH - Path to python-twisted webserver

1. Run it from the command line like so:

       ./send-to-kodi.sh -r kodibox:8080 -u user:pass https://vimeo.com/174312494

1. Edit config file $HOME/.config/send_to_kodi/.sendtokodi to override default settings:

       #!/usr/bin/env bash
       GUI=0
       DOWNLOAD_DIR=.
       KODI_YOUTUBE=0
       SEND_RAW=0
       SHARE_PORT=8080
       REMOTE=""
       LOGIN=""
       HOST_NAME=""
       RESOLUTION_HEIGHT=""
       RESOLUTION_BYPASS_LIST=("soundcloud.com" "yp.shoutcast.com")
       #display available formats
       LISTFORMATS=0 

1. Edit `send-to-kodi.desktop` add your credentials then copy it to your user folder (optional):

       chmod 600 send-to-kodi.desktop
       mkdir -p ~/.local/bin ~/.local/share/applications
       cp send-to-kodi.sh ~/.local/bin/send-to-kodi
       cp send-to-kodi.desktop ~/.local/share/applications/

1. Options:

       -d DIRECTORY           Temporary download directory for high quality streaming
       -l PORT                Local port number used for file sharing (default 8080)
       -r HOST:PORT           Kodi remote address
       -u USERNAME:PASSWORD   Kodi login credentials
       -x                     Do not try to resolve URL, just send it
       -y                     Use Kodi's youtube addon instead of youtube-dl
       -g                     enable zenity gui (default disabled)

       -v                     display git verion and last log entry

1. Commands:

        help                   display this help menu
        stop                   stop kodi playback
        next                   next kodi playback
        pause                  PlayPause toggle
        shutdown
        reboot
        active                 display Kodi active playlist id
        version                display git verion and last log entry
        exit|quit
        iptv                   load iptv interface (work in progress)

1. Custom commands implemented like the example below, in the following file: $HOME/.config/send_to_kodi/send_to_kodi_commands

       if [[ "$INPUT" =~ ^(command)$ ]]; then
           your-custom-command
           kodi_main #back to send-to-kodi.sh prompt
       fi

1. FZF syntax:

        sbtrkt       fuzzy-match	                Items that match sbtrkt
        'wild        exact-match (quoted)	        Items that include wild
        ^music       prefix-exact-match	            Items that start with music
        .mp3$        suffix-exact-match	            Items that end with .mp3
        !fire	     inverse-exact-match	        Items that do not include fire
        !^music      inverse-prefix-exact-match	    Items that do not start with music
        !.mp3$       inverse-suffix-exact-match	    Items that do not end with .mp3       

1. Note: to gracefully exit the iptv interface, clear screen with an invalid search then select empty field.

## Zenity dialogue

 ![Screenshot of dialog box](https://user-images.githubusercontent.com/7693838/119225728-d94f1000-bb05-11eb-9ff2-5a32d2974f55.png)
