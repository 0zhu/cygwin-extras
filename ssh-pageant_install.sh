#!/bin/bash
PATH=/usr/local/bin:/usr/bin

command -v ssh >/dev/null 2>&1 || { echo ssh is not installed, ssh-pageant implementation is not required; exit 1; }

echo Installing ssh-pageant https://github.com/cuviper/ssh-pageant
apt-cyg install ssh-pageant

PATHTOINSTALL=/etc/profile.d/ssh-pageant.sh

echo Applying ssh-pageant config https://github.com/cuviper/ssh-pageant#options to $PATHTOINSTALL
echo eval '$(/usr/bin/ssh-pageant -r -a "$HOME/.ssh/.ssh-pageant")' > $PATHTOINSTALL || { echo Error while applying ssh-pageant config; exit 1; }

# remove previous possible implementations
rm -f /opt/ssh-agent-tweak
sed -i '/\/opt\/ssh-agent-tweak/d' ~/.bashrc >/dev/null 2>&1
exit 0
