#!/bin/bash

set -eu

if [[ $USER != "yves" ]]; then
	echo "$USER != yves"
fi

if [[ ! -d ~/.ssh ]]; then
  mkdir $HOME/.ssh
  chmod 700 $HOME/.ssh
  touch $HOME/.ssh/authorized_keys
fi

# The original keys are always merged with the original keys.
# If I didn't keep them in separate files, removing a key from github would
# never remove it from the server.
if [[ ! -s $HOME/.ssh/orig_keys ]]; then
  if [[ -s $HOME/.ssh/authorized_keys ]]; then
    mv $HOME/.ssh/authorized_keys ~/.ssh/orig_keys
  fi
fi

f=$(mktemp)
f2=$(mktemp)
wget -q -O $f "https://github.com/nictuku.keys"

cat <<EOF> $f2
# THIS FILE WAS AUTOGENERATED by github.com/nictuku/dot/keys.sh
# Any changes done here will be overwritten. Please change the orig_keys
# file instead.
EOF
if [[ -s $HOME/.ssh/orig_keys ]] ; then 
  sort -u $HOME/.ssh/orig_keys $f >> $f2
else 
  sort -u $f >> $f2
fi
mv $f2 $HOME/.ssh/authorized_keys
