#!/bin/sh
set -o nounset -o errexit

. ./config
export LASTFM_URL="http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&user=${LASTFM_USER}&api_key=${LASTFM_API_KEY}&format=json&limit=1"
export LATEST_FILE=/tmp/lastfm.latest

function post_to_hipchat() {
    COLOR=$1
    MESSAGE="$2"
    curl -s >/dev/null \
        --data-urlencode "auth_token=$HIPCHAT_TOKEN" \
        --data-urlencode "message_format=html" \
        --data-urlencode "room_id=$HIPCHAT_ROOM" \
        --data-urlencode "from=$HIPCHAT_FROM" \
        --data-urlencode "color=$COLOR" \
        --data-urlencode "message=$MESSAGE" \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        https://api.hipchat.com/v1/rooms/message 
}

PREVIOUS_SONG_URL=""
while true; do
  curl -s "${LASTFM_URL}" | jq '.recenttracks.track[] | select(."@attr".nowplaying == "true")' >$LATEST_FILE
  CURRENT_SONG_URL=$(cat $LATEST_FILE | jq .url | tr -d '"')
  if [ "${CURRENT_SONG_URL}" != "${PREVIOUS_SONG_URL}" ] ; then
    echo " flipped to ${CURRENT_SONG_URL}"
    PREVIOUS_SONG_URL="${CURRENT_SONG_URL}"
    MESSAGE=$(cat $LATEST_FILE | jq '.artist."#text" + " - <i>" + .name + "</i> - " + .album."#text"' | tr -d '"' | tr -d "'")
    post_to_hipchat green "${MESSAGE}"
  fi
  sleep 20
done
