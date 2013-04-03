#!/bin/bash

set -eu

if [[ $USER != "nictuku" ]]; then
	echo "$USER != nictuku"
fi

if [[ ! -d ~/.ssh ]]; then
  mkdir ~/.ssh
  chmod 700 ~/.ssh
  touch ˜/.ssh/authorized_keys
fi

# The original keys are always merged with the original keys.
# If I didn't keep them in separate files, removing a key from github would
# never remove it from the server.
if [[ ! -s ~/.ssh/orig_keys ]]; then
	mv ~/.ssh/authorized_keys ~/.ssh/orig_keys
fi

f=$(mktemp)
f2=$(mktemp)
wget -q -O $f "https://github.com/nictuku.keys"

cat <<EOF> $f2
# THIS FILE WAS AUTOGENERATED by github.com/nictuku/dot/keys.sh
# Any changes done here will be overwritten. Please change the orig_keys
# file instead.
EOF

sort -u ~/.ssh/orig_keys $f >> $f2
mv $f2 ~/.ssh/authorized_keys
