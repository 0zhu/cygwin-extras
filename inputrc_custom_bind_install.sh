#!/bin/bash
PATH=/usr/local/bin:/usr/bin

SCRIPTURL=https://github.com/zhubanRuban/cygwin-extras/raw/master/inputrc_custom_bind
PATHTOINSTALL=/etc/profile.d/inputrc.sh

echo Installing custom .inputrc via bind https://github.com/zhubanRuban/cygwin-extras/blob/master/inputrc_custom_bind
wget -nv --show-progress -O "$PATHTOINSTALL" "$SCRIPTURL"
