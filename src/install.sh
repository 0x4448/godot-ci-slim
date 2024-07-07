#!/bin/bash
set -eu

tempDir=$(mktemp -d)
pushd "$tempDir"
trap 'popd; rm -rf "$tempDir"' EXIT

apiUrl="https://api.github.com/repos/godotengine/godot/releases/tags/$GODOT_VERSION-stable"

curl -s "$apiUrl" |
  jq --raw-output \
  '.assets[] | select(.name | contains("x86_64") and contains("stable_linux")) | .browser_download_url' |
  xargs curl -fsSL -o godot.zip

unzip godot.zip
find . -type f -name 'Godot_*' -exec mv {} /usr/local/bin/godot \;
chmod +x /usr/local/bin/godot

curl -s "$apiUrl" |
  jq --raw-output \
  '.assets[] | select(.name | contains("stable_export")) | .browser_download_url' |
  xargs curl -fsSL -o templates.tpz

unzip templates.tpz
dest="/usr/local/share/godot/export_templates/$GODOT_VERSION.stable"
mkdir -p "$dest"
find templates/ -type f -not -name 'version.txt' -and -not -name "$EXPORT_PLATFORM*" -exec rm {} \;
cp -R templates/* "$dest"
