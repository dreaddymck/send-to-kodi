#!/bin/bash
shopt -s nocasematch

{
    type youtube-dl &>/dev/null
    ytdl="$(which youtube-dl)"
} ||
    {
        type yt-dlp &>/dev/null
        ytdl="$(which yt-dlp)"
    } ||
    error "youtube-dl and yt-dlp not installed"