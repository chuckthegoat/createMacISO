#!/bin/bash

if [[ $# != 2 ]]; then
	echo "Usage: createMacISO.sh /path/to/installer /path/to/output"
	exit 1
fi

installer_name=$(echo "$1" | sed 's/.*\/\(.*\.app\)/\1/g' | sed 's/\.app.*//g')

hdiutil create -o /tmp/MacOSX.cdr -size 8192m -layout SPUD -fs HFS+J
hdiutil attach /tmp/MacOSX.cdr.dmg -noverify -mountpoint /Volumes/install_build
sudo "$1/Contents/Resources/createinstallmedia" --volume /Volumes/install_build --applicationpath "$1"
hdiutil detach "/Volumes/$installer_name"
mv /tmp/MacOSX.cdr.dmg "$2.dmg"
hdiutil convert "$2.dmg" -format UDTO -o "$2.iso"
mv "$2.iso.dmg" "$2.iso"

exit 0
