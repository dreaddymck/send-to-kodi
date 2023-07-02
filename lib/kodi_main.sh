#!/bin/bash

kodi_main() {

    set -o history
    
    if [ -z $INPUT ]; then

        if ((GUI)); then
            INPUT="$(zenity --entry --title "Send to Kodi" --text "Paste a URL or press OK to select a file")" || exit
            [[ $INPUT ]] || INPUT="$(zenity --file-selection)" || kodi_main
        else         
            read -r -e -d $'\n' -p 'Enter[url/path/cmd]: ' INPUT

            history -s "$INPUT"

            if [[ "$INPUT" =~ ^(exit|quit)$ ]]; then
                unset INPUT
                exit
            fi
            if [[ "$INPUT" =~ ^(stop|halt)$ ]]; then
                kodi_stop
                unset INPUT
                kodi_main
            fi
            if [[ "$INPUT" =~ ^(shutdown)$ ]]; then
                kodi_shutdown
                unset INPUT
                kodi_main
            fi
            if [[ "$INPUT" =~ ^(reboot)$ ]]; then
                kodi_reboot
                unset INPUT
                kodi_main
            fi                        
            if [[ "$INPUT" =~ ^(next)$ ]]; then
                kodi_next
                unset INPUT
                kodi_main
            fi
            if [[ "$INPUT" =~ ^(iptv)$ ]]; then
                unset INPUT
                iptv_main
            fi
            if [[ "$INPUT" =~ ^(active)$ ]]; then
                unset INPUT
                kodi_get_active
                kodi_main
            fi
            if [[ "$INPUT" =~ ^(help)$ ]]; then
                unset INPUT
                show_help
                kodi_main
            fi
            if [[ -z $INPUT ]]; then
                kodi_main                
            fi
        fi
    fi

    trap 'cleanup' EXIT

    # Don't try to resolve
    if ((SEND_RAW)); then
        url="$INPUT"
    elif [[ $INPUT =~ ^! ]]; then
        url="${INPUT:1}"
    # Local file
    elif [[ -f $INPUT ]]; then
        serve "$INPUT"
        url="http://$HOST_NAME:$SHARE_PORT/media"
    # Other protocols
    elif ! [[ $INPUT =~ ^https?:// ]]; then
        url="$INPUT"
    # Formats supported by Kodi
    elif [[ $INPUT =~ \.(mp[g34]|mk[va]|mov|avi|flv|wmv|asf|flac|m4[av]|aac|og[gm]|pls|jpe?g|png|gif|jpe?g|tiff|m3u8?)(\?.*)?$ ]]; then
        url="$INPUT"
    # youtube.com / youtu.be
    elif ((KODI_YOUTUBE)) && [[ $INPUT =~ ^https?://(www\.)?youtu(\.be/|be\.com/watch\?v=) ]]; then
        id="$(sed -E 's%.*(youtu\.be/|[&?]v=)([a-zA-Z0-9_-]+).*%\2%' <<<"$INPUT")"
        url="plugin://plugin.video.youtube/?action=play_video&videoid=$id"
    # youtube-dl
    else
        # youtube-dl -g may output different kinds of URL's:
        #
        # 1. Single video URL
        #    This can be played by Kodi directly, most of the time.
        #    Sometimes this will be an MPD and we'll have to do step 3.
        #
        # 2. Video URL + Audio URL
        #    This needs downloading and muxing, which youtube-dl will do for us.
        #    Kodi can do that natively, but only for local media.
        #    Only when an audio file has the same name as a video file.
        #    It doesn't work for STRM files...
        #
        #    If only... Player.Open {"file":"http://video.mp4", "ext_audio":"http://audio.mp3"}
        #
        # 3. MPD + same MPD
        #    Kodi supports MPD playback with InputStream.Adaptive.
        #    Only way to trigger that is through an addon, or by using #KODIPROP in a STRM file.
        #    In my testing the two MPD's provided by youtube-dl have been identical.
        #
        #    If only... Player.Open {"file":"http://playlist.mpd"}
        #
        # 4. Video MPD + Audio MPD (?)
        #    IF this exists, we have to do step 2.
        #
        # 5. ISM or HLS (?)
        #    Kodi has support for these, the same way 3. is done, but I haven't implemented it
        #    in the script, because I have no sites to test on.
        # 

        if ((HEIGHT)); then
            echo "Searching for resolution: ${HEIGHT}p" >&2
            url="$($ytdl -gf best[height=$HEIGHT] "$INPUT")" || echo "No $HEIGHT videos found" >&2        
        fi

        if [[ -z $url ]]; then
            echo "Looking for compatible" >&2
            url="$($ytdl -gf b "$INPUT")"  || echo "No COMPATIBLE videos found"  >&2
        fi          

        if [[ -z $url ]]; then
            echo "Searching for resolution: BEST" >&2
            best="$($ytdl -g "$INPUT")" || echo "No BEST videos found" >&2 && unset INPUT && kodi_main
        fi          

        dash='^[^?]*\.mpd(\?|$)'

        # There is a better URL (but it will need some pre-processing)
        if ((best)); then

            video="$(head -n1 <<< "$best" | tail -n1)"
            audio="$(head -n2 <<< "$best" | tail -n1)"

            # MPEG-DASH question
            if [[ $video == "$audio" && $video =~ $dash ]]; then
                # [[ -z $url || $url =~ $dash ]] || question "Use MPEG-DASH for better quality?" && url="$video"
                [[ -z $url || $url =~ $dash ]] || url="$video"

            # Download with youtube-dl
            elif [[ -z $url ]]; then
                download_and_serve "$INPUT"
                url="http://$HOST_NAME:$SHARE_PORT/media"
            fi
        fi

        # MPEG-DASH
        # Do this down here since both $url and $best can be a MPD
        if [[ $url =~ $dash ]]; then
            serve  # create TMP_DIR
            (echo '#KODIPROP:inputstream=inputstream.adaptive'
            echo '#KODIPROP:inputstream.adaptive.manifest_type=mpd'
            echo "$video") > "$TMP_DIR/media.strm"
            url="http://$HOST_NAME:$SHARE_PORT/media.strm"
        fi
    fi

    kodi_get_active

    if [[ $response == *'"type":"video"'* ]]; then
        echo "Queueing" >&2
        kodi_request '{"jsonrpc":"2.0","method":"Playlist.Add","params":{"item":{"file":"'"$url"'"},"playlistid":0},"id":1}'
    else
        echo "Playing" >&2
        kodi_request '{"jsonrpc":"2.0","method":"Player.Open","params":{"item":{"file":"'"$url"'"}},"id":1}'
    fi

    unset INPUT

    # Maybe wait for server (trap will kill it on EXIT)
    if [[ $TWISTED_PID ]]; then
        if ((GUI)); then
            zenity --info --no-wrap --text "File share active" --ok-label "Stop"
        else
            echo "File share active, press Ctrl+C to abort..." >&2
            wait
        fi
    fi
    if((CYA)); then
        exit
    fi
    kodi_main
}