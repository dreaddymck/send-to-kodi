#!/bin/bash

# Download using youtube-dl and maybe show progress bar
# args: URL
download_and_serve() {
    echo "Getting video title..." >&2
    TMP_FILE="$($ytdl --get-filename "$1")"
    file="${DOWNLOAD_DIR:?}/$TMP_FILE"

    echo "Downloading video..." >&2
    if ((GUI)); then
        # Filter out the percentage but only 2 digits, never print 100 as it will kill zenity
        zenity --progress --auto-close --text "Downloading video..." < <($ytdl -o "$file" --newline "$1" | sed -Eun 's/.* ([0-9][0-9]?)\.[0-9]%.*/\1/p') || exit
    else
        $ytdl -o "$file" "$1"
    fi

    # Sometimes youtube-dl changes the filename from mp4 to mkv
    if [[ ! -f $file ]]; then
        file="${file%.*}.mkv"
        TMP_FILE="${TMP_FILE%.*}.mkv"
        [[ -f $file ]] || error "Download failed"
    fi

    serve "$file"
}

# Start webserver in a background process
# args: FILE
serve() {
    # Kodi is a request monster which will kill most of these:
    # https://unix.stackexchange.com/questions/32182/simple-command-line-http-server
    # 1. netcat won't work because Kodi will try two GET requests at the same time
    # 2. Python http.server raises BrokenPipeError sometimes with big files,
    #    and also some other error because Kodi keeps breaking the connection
    # 3. Twisted has worked so far for me, but it's a bit fat, I know

    [[ $TWISTED_PATH ]] || TWISTED_PATH="$(type -p twist || type -p twist3)"
    [[ $TWISTED_PATH ]] || error "python-twisted is not installed"

    # Prepare a directory
    TMP_DIR="$(mktemp -d /tmp/send-to-kodi-XXXX)" || error "Failed to create shared directory"
    if [[ $1 ]]; then
        ln -s "$(realpath "$1")" "$TMP_DIR/media" || error "Failed to write to shared directory"
    fi

    echo "Starting webserver..." >&2
    "$TWISTED_PATH" web --path "$TMP_DIR" --listen "tcp:$SHARE_PORT" &
    TWISTED_PID=$!

    # Give it a few secs to start up
    sleep 3s
}