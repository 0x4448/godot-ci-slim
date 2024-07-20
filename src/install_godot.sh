#!/bin/bash
# Builder stage: download Godot and templates, which will be copied to the final image

set -eu

### Install Packages ###
echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99retries
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
if [ "$DOTNET" == "true" ]; then
  label="stable_mono_linux"
else
  label="stable_linux"
fi

release=$(curl -fsLS --retry 5 "https://api.github.com/repos/godotengine/godot/releases/tags/$GODOT_VERSION-stable")

echo "$release" | jq --raw-output \
  ".assets[] | select(.name | contains(\"x86_64\") and contains(\"$label\")) | .browser_download_url" |
  xargs curl -fsLS --retry 5 -o godot.zip

unzip godot.zip

if [ "$DOTNET" == "true" ]; then
  find . -maxdepth 2 -type d -name 'GodotSharp' -exec mv {} /usr/local/bin/ \;
else
  mkdir /usr/local/bin/GodotSharp/
fi

find . -type f -name 'Godot_*' -exec mv {} /usr/local/bin/godot \;
chmod +x /usr/local/bin/godot


### Install Godot Templates ###
echo "$release" | jq --raw-output \
  '.assets[] | select(.name | contains("stable_export")) | .browser_download_url' |
  xargs curl -fsLS --retry 5 -o templates.tpz

unzip templates.tpz

if [ "$DOTNET" == "true" ]; then
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
