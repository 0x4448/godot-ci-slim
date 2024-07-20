#!/bin/bash
set -eu

templatePath=local/share/godot/export_templates
mkdir -v -p "$HOME/.$templatePath"
mv /usr/${templatePath}/* "$HOME/.$templatePath"

mkdir -v -p "$(pwd)/export"

if [[ "$1" =~ "linux" ]]; then
  godot --headless --verbose --path sample_project --export-release Linux/X11 "$(pwd)/export/game"
elif [[ "$1" =~ "web" ]]; then
  godot --headless --verbose --path sample_project --export-release Web "$(pwd)/export/index.html"
fi
