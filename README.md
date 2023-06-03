# Send to Kodi 

* Send compatible youtube-dl/yt-dlp streams to Kodi.
* Send compatible local media to Kodi.
* MPEG-DASH (high quality video) support.
* Kodi add-ons may be required for proprietory media streams.
* Zenity input interface 
* IPTV m3u interface (__Work In Progress__)

## Installation

1. In Kodi, enable *System > Servicies > Web server > Allow remote control via HTTP*.

1. Install on your Kodi box:
   - `InputStream.Adaptive` to enable MPEG-DASH support.
   - *Youtube add-on* for better youtube support.

1. Install on your Linux machine:
   - `youtube-dl or yt-dlp` to add support for hundreds of video sites.   
   - `python-twisted` to enable local file sharing and MPEG-DASH support.
   - `jq`                      JSON Processing
   - `zenity`                  Graphical interface
   - `PhantomJS`               Scriptable Headless Browser
   
1. Environment variables: TWISTED_PATH - Path to python-twisted webserver      

1. Now you can run it from the command line like so:

       ./send-to-kodi.sh -r kodibox:8080 -u kodi:SomePassword https://vimeo.com/174312494


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

## Zenity dialogue

 ![Screenshot of dialog box](https://user-images.githubusercontent.com/7693838/119225728-d94f1000-bb05-11eb-9ff2-5a32d2974f55.png)
