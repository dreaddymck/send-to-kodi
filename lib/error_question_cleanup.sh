#!/bin/bash

# Show a error dialog or message
# args: MESSAGE
error() {
    if ((GUI)); then
        zenity --error --ellipsize --text "$1"
    else
        printf '%s\n' "$1" >&2
    fi
    exit 1
}
# Show a question dialog or prompt
# args: MESSAGE
question() {
    if ((GUI)); then
        zenity --question --ellipsize --text "$1"
    else
        printf '%s [y/N] ' "$1" >&2
        read -r
        [[ $REPLY =~ y|Y ]]
    fi
}
# The EXIT trap
cleanup() {
    if [[ -d $TMP_DIR ]]; then
        [[ -L $TMP_DIR/media ]] && rm "$TMP_DIR/media"
        [[ -f $TMP_DIR/media.strm ]] && rm "$TMP_DIR/media.strm"
        rmdir "$TMP_DIR"
    fi
    if [[ -d $DOWNLOAD_DIR && -f $DOWNLOAD_DIR/$TMP_FILE ]]; then
        question "Delete $TMP_FILE?" && rm "$DOWNLOAD_DIR/$TMP_FILE"
    fi
    [[ $TWISTED_PID ]] && kill "$TWISTED_PID"
}