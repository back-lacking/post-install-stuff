#! /bin/bash
SYNCTHING_REPO_URL="https://github.com/syncthing/syncthing/releases/latest"
SYNCTHING_REDIRECT_URL=$(curl -s -I $SYNCTHING_REPO_URL -L | awk '/Location: (.*)/ {print $2}' | tail -n 1)
SYNCTHING_VERSION=$(echo $SYNCTHING_REDIRECT_URL | grep -E "/(?<=/tag\/)(.*)(?=\/)/s")
# url/downloads/blah/tag/$($SYNCTHING_VERSION)/downloadsorwhatever/$($SYNCTHING_VERSION)-linux-amd64-unicorns.7z
wget https://github.com/syncthing/syncthing/releases/download/$($SYNCTHING_VERSION)/syncthing-linux-$($SYNCTHING_VERSION).tar.gz --trust-server-names