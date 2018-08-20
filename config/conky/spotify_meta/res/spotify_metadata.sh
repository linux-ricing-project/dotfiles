#!/bin/bash

param_meta=$1

get-metadata(){
  SP_DEST="org.mpris.MediaPlayer2.spotify"
  SP_PATH="/org/mpris/MediaPlayer2"
  SP_MEMB="org.mpris.MediaPlayer2.Player"

  dbus-send                                                                   \
  --print-reply                                  `# We need the reply.`       \
  --dest=$SP_DEST                                                             \
  $SP_PATH                                                                    \
  org.freedesktop.DBus.Properties.Get                                         \
  string:"$SP_MEMB" string:'Metadata'                                         \
  | grep -Ev "^method"                           `# Ignore the first line.`   \
  | grep -Eo '("(.*)")|(\b[0-9][a-zA-Z0-9.]*\b)' `# Filter interesting fiels.`\
  | sed -E '2~2 a|'                              `# Mark odd fields.`         \
  | tr -d '\n'                                   `# Remove all newlines.`     \
  | sed -E 's/\|/\n/g'                           `# Restore newlines.`        \
  | sed -E 's/(xesam:)|(mpris:)//'               `# Remove ns prefixes.`      \
  | sed -E 's/^"//'                              `# Strip leading...`         \
  | sed -E 's/"$//'                              `# ...and trailing quotes.`  \
  | sed -E 's/"+/|/'                             `# Regard "" as seperator.`  \
  | sed -E 's/ +/ /g'                            `# Merge consecutive spaces.`
}

get-albumart(){
  cd ~ > /dev/null
  spotify_uri=$(get-metadata | grep "artUrl" | cut -d "|" -f2)

  url=$(curl -si "$spotify_uri" |\
  		grep "Location" |\
  		awk '{print $2}')

  curl -o "$HOME/.config/conky/spotify_meta/conky_image" ${url%$'\r'}
}

psgrep "spotify"

case "$param_meta" in
  --artist) get-metadata | grep "artist" | cut -d "|" -f2 ;;
  --title) get-metadata | grep "title" | cut -d "|" -f2 ;;
  --album) get-metadata | grep "album" | cut -d "|" -f2 | head -n1 ;;
  --album-art) get-albumart ;;
esac
