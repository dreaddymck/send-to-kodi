# Send to Kodi DMCK

Two github projects combined.

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
2. Install on your Kodi box:

   * `InputStream.Adaptive` to enable MPEG-DASH support.
   * *Kodi add-ons* for proprietory media support.
3. Install to your Linux environment:

   * `yt-dlp`           to add support for hundreds of video sites.
   * `jq`               JSON Processing
   * `fzf`              required for iptv interface (optional) - https://github.com/junegunn/fzf
   * `python-twisted`   to enable local file sharing and MPEG-DASH support (optional). Environment variables: TWISTED_PATH - Path to python-twisted webserver
   * `zenity`           Graphical interface (optional)
   * `PhantomJS`        Scriptable Headless Browser (optional)
4. Run it from the command line:

   ```bash
   ./send-to-kodi.sh -r kodibox:8080 -u user:pass https://vimeo.com/174312494
   ```
5. Edit config file $HOME/.config/send_to_kodi/.sendtokodi to customize default settings:

   ```bash
   #!/usr/bin/env bash
   GUI=0
   DOWNLOAD_DIR=.
   KODI_YOUTUBE=0
   SEND_RAW=0
   REMOTE="kodibox:8080"
   LOGIN="username:password"
   HOST_NAME="$(hostname -i )"
   SHARE_PORT=8080
   USER_AGENT="Mozilla/5.0 (Android 14; Mobile; rv:68.0) Gecko/68.0 Firefox/128.0"
   RESOLUTION_JSON='[
      {"res":"360", "value" : ["twitch.tv","youtube.com"]}
   ]'
   #display available formats
   LISTFORMATS=0
   ```
6. Edit `send-to-kodi.desktop` add your credentials then copy it to your user folder (optional):

   ```bash
   chmod 600 send-to-kodi.desktop
   mkdir -p ~/.local/bin ~/.local/share/applications
   cp send-to-kodi.sh ~/.local/bin/send-to-kodi
   cp send-to-kodi.desktop ~/.local/share/applications/
   ```
7. Options:

   ```text
   -d DIRECTORY           Temporary download directory for high quality streaming
   -l PORT                Local port number used for file sharing (default 8080)
   -r HOST:PORT           Kodi remote address
   -u USERNAME:PASSWORD   Kodi login credentials
   -x                     Do not try to resolve URL, just send it
   -y                     Use Kodi's youtube addon instead of youtube-dl
   -g                     enable zenity gui (default disabled)

   -v                     display git version and last log entry
   ```
8. Commands:

   ```text
   help                   display this help menu
   stop                   stop kodi playback
   next                   next kodi playback
   previous|prev          previous kodi playback
   volume|vol 100         set volume 100%
   pause                  PlayPause toggle
   shutdown
   reboot
   active                 display Kodi active playlist id
   version                display git version and last log entry
   exit|quit
   iptv                   load iptv interface (work in progress)
   ```
9. Ad custom commands to the following script: $HOME/.config/send_to_kodi/send_to_kodi_commands

   ```bash
   if [[ "$INPUT" =~ ^(command)$ ]]; then
       your-custom-command
       kodi_main #back to send-to-kodi.sh prompt
   fi
   ```
10. IPTV FZF search syntax:
    ```text
    sbtrkt       fuzzy-match	                Items that match sbtrkt
    'wild        exact-match (quoted)	        Items that include wild
    ^music       prefix-exact-match	            Items that start with music
    .mp3$        suffix-exact-match	            Items that end with .mp3
    !fire	     inverse-exact-match	        Items that do not include fire
    !^music      inverse-prefix-exact-match	    Items that do not start with music
    !.mp3$       inverse-suffix-exact-match	    Items that do not end with .mp3
    ```

11. Note: Gracefully exit the iptv interface with `ctrl+c` or use an an invalid search then select the empty field.

## Zenity dialogue

 ![Screenshot of dialog box](https://user-images.githubusercontent.com/7693838/119225728-d94f1000-bb05-11eb-9ff2-5a32d2974f55.png)
