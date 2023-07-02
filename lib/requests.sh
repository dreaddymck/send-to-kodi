#!/bin/bash

# kodi commands
kodi_stop() {
    kodi_get_active
    if [[ ! -z $active_player ]]; then
        echo "Request stop:" >&2
        kodi_request '{"jsonrpc": "2.0", "method":"Player.Stop", "params": { "playerid": '"$active_player"' }, "id":1}'
    fi
}
kodi_next() {
    kodi_get_active
    if [[ ! -z $active_player ]]; then
        echo "Request next:" >&2
        kodi_request '{"jsonrpc": "2.0", "method":"Player.GoTo", "params": { "playerid": '"$active_player"', "to":"next" }, "id":1}'
    fi
}
kodi_get_active() {
    kodi_request '{"jsonrpc": "2.0", "method": "Player.GetActivePlayers", "id":1}'
    [[ $? ]] || error "Failed to send - is Kodi running?"
    if [[ $response ]]; then
        # echo "$response"  >&2
        active_player=$(echo "$response" | jq -c '.result[] | select(.type | contains("video")).playerid')
    fi
    # echo "Player id: $active_player"
}
kodi_shutdown() {
    echo "Request system shutdown:" >&2
    kodi_request '{"jsonrpc": "2.0", "method": "System.Shutdown"}'
}
kodi_reboot() {
    echo "Request system reboot:" >&2
    kodi_request '{"jsonrpc": "2.0", "method": "System.Reboot"}'
}
kodi_request(){    
    response="$(curl -X POST -H 'Content-Type: application/json' ${LOGIN:+--user "$LOGIN"} -d "$1"  "http://$REMOTE/jsonrpc" 2>/dev/null)"
    echo "$1" >&2
    echo "$response" >&2
    ! [[ $response =~ '"error":' ]] || error $response
}