command -v ssh >/dev/null 2>&1 || exit
command -v ssh >/dev/null 2>&1 || apt-cyg install ssh-pageant

PATHTOINSTALL=/etc/profile.d/ssh-pageant.sh

echo Installing ssh-pageant https://github.com/cuviper/ssh-pageant#options
echo eval '$(/usr/bin/ssh-pageant -r -a "$HOME/.ssh/.ssh-pageant")' > $PATHTOINSTALL

# remove previous possible implementations
rm -f /opt/ssh-agent-tweak
sed -i '/\/opt\/ssh-agent-tweak/d' ~/.bashrc"
