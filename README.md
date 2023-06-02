# Send to Kodi 

![Screenshot of dialog box](https://user-images.githubusercontent.com/7693838/119225728-d94f1000-bb05-11eb-9ff2-5a32d2974f55.png)

* Paste an URL to play it on Kodi.
* Stream files from your computer to Kodi.
* Uses `youtube-dl or yt-dlp` to support hundreds of sites.
* MPEG-DASH (high quality video) support.
* No Kodi add-ons required for standard video.

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
   - `iptv`                    CLI IPTV player for M3U playlists in your terminal.
   - `PhantomJS`               Scriptable Headless Browser
   
1. Environment variables: TWISTED_PATH - Path to python-twisted webserver      

1. Now you can run it from the command line like so:

       ./send-to-kodi -r kodibox:8080 -u kodi:SomePassword https://vimeo.com/174312494
   
1. For a more polished experience, edit `send-to-kodi.desktop` and add your credentials.
   
1. Copy to system folders:
   
       sudo cp send-to-kodi.sh /usr/local/bin/
       sudo cp send-to-kodi.desktop /usr/share/applications/
