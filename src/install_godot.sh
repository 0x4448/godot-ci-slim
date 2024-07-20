#!/bin/bash
set -eu

### Install Packages ###
apt-get update
apt-get install --yes --no-install-recommends \
    brotli \
    ca-certificates \
    curl \
    jq \
    unzip

rm -rf /var/lib/apt/lists/*

tempDir=$(mktemp -d)
pushd "$tempDir"
trap 'popd; rm -rf "$tempDir"' EXIT


### Install Godot ###
apiUrl="https://api.github.com/repos/godotengine/godot/releases/tags/$GODOT_VERSION-stable"

if [[ "$DOTNET" == "true" ]]; then
  label="stable_mono_linux"
else
  label="stable_linux"
fi

curl -s "$apiUrl" |
  jq --raw-output \
  ".assets[] | select(.name | contains(\"x86_64\") and contains(\"$label\")) | .browser_download_url" |
  xargs curl -fsSL -o godot.zip

unzip godot.zip

if [[ "$DOTNET" == "true" ]]; then
  find . -maxdepth 2 -type d -name 'GodotSharp' -exec mv {} /usr/local/bin/ \;
else
  mkdir /usr/local/bin/GodotSharp/
fi

find . -type f -name 'Godot_*' -exec mv {} /usr/local/bin/godot \;
chmod +x /usr/local/bin/godot


### Install Godot Templates ###
curl -s "$apiUrl" |
  jq --raw-output \
  '.assets[] | select(.name | contains("stable_export")) | .browser_download_url' |
  xargs curl -fsSL -o templates.tpz

unzip templates.tpz

if [[ "$DOTNET" == "true" ]]; then
  dest="/usr/local/share/godot/export_templates/$GODOT_VERSION.stable.mono"
else
  dest="/usr/local/share/godot/export_templates/$GODOT_VERSION.stable"
fi

mkdir -p "$dest"

# Remove unnecessary templates to make the image smaller
find templates/ -type f -not -name 'version.txt' -and -not -name "$EXPORT_PLATFORM*" -exec rm {} \;
find templates/ -type f -name "linux*" -and -not -name "*x86_64" -exec rm {} \;
find templates/ -type f -name "windows*" -and -not -name "*x86_64*" -exec rm {} \;

cp -R templates/* "$dest"
