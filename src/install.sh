#!/bin/bash
# Final stage: install Git and .NET (optional)

set -eu

echo 'Acquire::Retries "5";' > /etc/apt/apt.conf.d/99retries
apt-get update
apt-get install --yes --no-install-recommends \
  ca-certificates \
  git \
  git-lfs \
  libfontconfig

if [ "$DOTNET" == "true" ]; then
  apt-get install --yes --no-install-recommends curl
  curl -fsLOS --retry 5 https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
  dpkg -i packages-microsoft-prod.deb
  rm packages-microsoft-prod.deb
  apt-get update
  apt-get install --yes --no-install-recommends dotnet-sdk-8.0
fi

rm -rf /var/lib/apt/lists/*
