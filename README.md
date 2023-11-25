# Send to Kodi 

* Send compatible yt-dlp/youtube-dl streams to Kodi.
* Send compatible local media to Kodi.
* MPEG-DASH (high quality video) support.
* Kodi add-ons may be required for proprietory media streams.
* Zenity input interface
* IPTV m3u interface (__Work In Progress__)

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

1. Now you can run it from the command line like so:

       ./send-to-kodi.sh -r kodibox:8080 -u user:pass https://vimeo.com/174312494

1. Or create config file ~/.sendtokodi and set values:

       #!/bin/bash
       GUI=0
       DOWNLOAD_DIR=.
       KODI_YOUTUBE=0
       SEND_RAW=0
       SHARE_PORT=8080
       REMOTE="192.168.1.10:8080"
       LOGIN="user:pass"
       HOST_NAME="$(hostname -I | awk '{print $1}')" #ipv4 if hostname is not visible
       HEIGHT="360"

1. For a more polished experience, edit `send-to-kodi.desktop` and add your credentials.

1. Copy to system folders:

       sudo cp send-to-kodi.sh /usr/local/bin/
       sudo cp send-to-kodi.desktop /usr/share/applications/

1. Usage: send-to-kodi.sh [options] -r HOST:PORT [URL|FILE]

Send a local or online video to Kodi. Run without URL to get a GUI.
In the GUI, you may prepend an URL with ! to disable resolving (like -x).

1. Options:
  -d DIRECTORY           Temporary download directory for high quality streaming
  -l PORT                Local port number used for file sharing (default 8080)
  -r HOST:PORT           Kodi remote address
  -u USERNAME:PASSWORD   Kodi login credentials
  -x                     Do not try to resolve URL, just send it
  -y                     Use Kodi's youtube addon instead of youtube-dl

  -s|--stop              stop kodi playback
  -n|--next              next kodi playback
  --shutdown
  --reboot
  --active               display Kodi active playlist id
  --version              display git verion and last log entry
  --iptv                 load iptv interface
  -g                     enable zenity gui (default disabled)

Commands:
  help                   display this help menu
  stop                   stop kodi playback
  next                   next kodi playback
  shutdown
  reboot
  active                 display Kodi active playlist id
  version                display git verion and last log entry
  iptv                   load iptv interface (work in progress)
  
## Zenity dialogue

 ![Screenshot of dialog box](https://user-images.githubusercontent.com/7693838/119225728-d94f1000-bb05-11eb-9ff2-5a32d2974f55.png)
