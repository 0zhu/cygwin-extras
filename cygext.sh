#!/bin/bash

#   Copyright 2019 zhubanRuban https://github.com/zhubanRuban/
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

COMPRESS=
UPDATE=

helpf() {
echo "
Usage: $SCRIPT \"package1 package2 ...\" packagename OPTION
Options:
	--standalone
	--nodependencies
	--mxt
	--cygutils
"
exit 0
}

SCRIPT=$0
ARGS=$@

grep -q -- --help <<< "$ARGS" && helpf
[ -z "$1" ] && helpf

#[ -z ${MOBASTARTUPDIR+x} ] || {
#	echo DON\'T run this script from Mobaxterm, use Cygwin instead:
#	echo https://github.com/zhubanRuban/cygwin-portable
#	exit 1
#}

echo; echo Checking if required packages exist...
command -v wget || { echo wget does not exist, exiting; exit 1; }
command -v apt-cyg || { echo apt-cyg does not exist, exiting; exit 1; }
command -v zip || apt-cyg install zip
command -v unzip || apt-cyg install unzip
command -v dos2unix || apt-cyg install dos2unix

[[ $1 != --* ]] && PACKAGES=$1
[[ $2 != --* ]] && PACKNAME=$2

[ -z "${PACKNAME:-}" ] && {
	grep -q -- --mxt <<< "$ARGS" && PACKNAME=${PACKAGES/ /}.mxt3 || {
		[ -z ${MOBASTARTUPDIR+x} ] && PACKNAME=${PACKAGES/ /}.zip || PACKNAME=${PACKAGES/ /}.mxt3
	}
}

mxtext() {
[ -z ${MOBASTARTUPDIR+x} ] && return

apt-cyg update

SETUPINI="$HOME/.aptcyg/setup.ini"
CYGSETUP="$(pwd)/mxtext-setup.ini.cygwin"

function getcygsetup {
	wget -O "${CYGSETUP}.xz" $(grep ' Mirror' "$SETUPINI"|head -n1|cut -d\| -f2)/$(uname -m|sed 's/i686/x86/g')/setup.xz
	unxz "${CYGSETUP}.xz" -c > "$CYGSETUP"
}

function depends {
	for PKG in "$@"; do echo -n .
		grep -q "^$PKG$" <<< "$DEPS" && continue || DEPS="$DEPS"$'\n'"$PKG"
		depends $(sed -n "/^@ $PKG$/,/^@/p" "$CYGSETUP"|grep ^requires:|awk -F': ' '{print $2}')
	done
}

function installf {
	for PKG in "$@"; do
		apt-cyg install "$PKG" || {
			sed -n "/^@ $PKG$/,/^@/p" "$CYGSETUP" | head -n -2 | sed '/\[prev\]/,/^$/d' | grep -E '^@|^sdesc:|^requires:|^version:|^install:' | sed 's/^[^:]*: //' | sed 's/"//g' | sed "\$acmd:  " >> "$SETUPINI"
			apt-cyg install "$PKG"
		}
	done
}

function listfiles {
	for PKG in "$@"; do
		for ARCHIVE in $(grep "^$PKG " /etc/setup/installed.db|awk '{print $2}'); do
			gzip -cd /etc/setup/${ARCHIVE}.lst.gz | grep -v /$ | sed 's/^/\//g; s/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g'
		done
	done
}

getcygsetup
grep -q -- --nodependencies <<< "$ARGS" && {
	installf $PACKAGES
	zip $COMPRESS $UPDATE "$PACKNAME" $(listfiles $PACKAGES)
} || {
	echo -n Parsing dependencies; depends $PACKAGES; echo
	installf $DEPS
	zip $COMPRESS $UPDATE "$PACKNAME" $(listfiles $DEPS)
}

rm -f "$(pwd)/mxtext-"*
rm -rf "$HOME/.aptcyg"
completedf
exit
}

mxtf() {

grep -q -- --mxt <<< "$ARGS" || return
[ -z "$PACKAGES" ] || grep -q -- --cygutils <<< "$ARGS" || return

PLUGINFILE=CygUtils.plugin
echo; wget -O $PLUGINFILE https://mobaxterm.mobatek.net/$PLUGINFILE
PACKNAME=$PLUGINFILE

grep -q -- --cygutils <<< "$ARGS" && return

# Check installed packages in mxt:
# apt-cyg update && cat /etc/setup/*installed*|awk '{print $1}'
#
# As of Sep 2019:
# base-files base-files-4.2-2.tar.bz2 0
# bash bash-4.1.16-4.tar.bz2 0
# cygwin cygwin-1.7.34-6.tar.bz2 0
# openssh openssh-6.7.1p1-1.tar.bz2 0
# xorg-server xorg-server-1.16.3-1.tar.bz2 0
# grep grep-2.16-1.tar.bz2 0
#
# IF this changes, do not forget to update explusions in dependencies section:
# apt-cyg update && cat /etc/setup/*installed*|awk '{print $1}'|sed 's/^/\^/g; s/$/\$/g'|sed ':a;N;$!ba;s/\n/|/g'
# ^base-files$|^bash$|^cygwin$|^openssh$|^xorg-server$|^grep$

echo; echo Gathering package information...
echo -e Legend: "\e[0;31mnotfound\e[0m \e[0;32mfound\e[0m localpackage \e[4;40mrepopackage\e[0m"
for FILE in $(unzip -Z1 $PLUGINFILE|grep ^bin/|sort|uniq|sed '/^bin\/$/d; s/^/\//g'); do
	FOUNDPKGS=
	FOUNDPKG=
	FOUNDREPOPKG=
	FOUNDPKG=$(cygcheck -f $FILE|awk -F'-[0-9].[0-9]' '{print $1}'|sed '/-debug/d'|uniq)
	if [ -z "$FOUNDPKG" ]; then
		FOUNDREPOPKG=$(cygcheck -p ${FILE}$|awk -F ' - |:' '{print $2}'|sed '/-debug/d'|uniq)
		[ -z "$FOUNDREPOPKG" ] || {
			ALLFOUNDREPOPKG="$ALLFOUNDREPOPKG
$FOUNDREPOPKG"
			FOUNDPKGS="$FOUNDREPOPKG"
		}
	else
		FOUNDPKGS="$FOUNDPKG"
	fi
	if [ -z "$FOUNDPKGS" ]; then
		echo -e "\e[0;31m$FILE\e[0m"
	else
		ALLFOUNDPKGS="$ALLFOUNDPKGS
$FOUNDPKGS"
		echo -e "\e[0;32m"$FILE"\e[0m" "\e[4;40m"$FOUNDREPOPKG"\e[0m" $FOUNDPKG
	fi
done

[ -z "$ALLFOUNDREPOPKG" ] || echo -e "\n"Packages found in Cygwin repo: $(sort <<< "$ALLFOUNDREPOPKG"|uniq)
[ -z "$ALLFOUNDPKGS" ] || {
	echo; echo All packages found: $(sort <<< "$ALLFOUNDPKGS"|uniq)
	echo; echo Cygwin setup format: $(sort <<< "$ALLFOUNDPKGS"|uniq|sed ':a;N;$!ba;s/\n/,/g')
}

rm -f $PLUGINFILE
exit
}

standalonef() {
[ -z "$PACKAGES" ] && return
grep -q -- --standalone <<< "$ARGS" || return
echo =========STANDALONE==========
if grep -q -- --mxt <<< "$ARGS"; then
	zip $COMPRESS $UPDATE "$PACKNAME" $(cygpath -u $(cygcheck $PACKAGES 2>/dev/null|grep -Evi '^Found: |\\WINDOWS\\|cygwin1.dll'|sed 's/>- //g')|sed 's/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g')
else
	zip $COMPRESS $UPDATE "$PACKNAME" $(cygpath -u $(cygcheck $PACKAGES 2>/dev/null|grep -Evi '^Found: |\\WINDOWS\\'|sed 's/>- //g')|sed 's/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g')
fi
}

packagef() {
[ -z "$PACKAGES" ] && return
echo ===========PACKAGE===========
apt-cyg install $PACKAGES
zip $COMPRESS $UPDATE "$PACKNAME" $(cygcheck -l $PACKAGES|sed 's/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g')
}

dependenciesf() {
[ -z "$PACKAGES" ] && return
echo =========DEPENDENCIES========
if grep -q -- --nodependencies <<< "$ARGS"; then
	echo; echo Dependencies for: $PACKAGES
	if grep -q -- --mxt <<< "$ARGS"; then
		apt-cyg depends $PACKAGES|sed 's/ > /\n/g'|sort|uniq|grep -Evi "$(sed 's/^/\^/; s/ /\$|\^/g; s/$/\$/' <<< "$PACKAGES")"|grep -Evi '^base-files$|^bash$|^cygwin$|^openssh$|^xorg-server$|^grep$'
	else
		apt-cyg depends $PACKAGES|sed 's/ > /\n/g'|sort|uniq|grep -Evi "$(sed 's/^/\^/; s/ /\$|\^/g; s/$/\$/' <<< "$PACKAGES")"
	fi
else
	if grep -q -- --mxt <<< "$ARGS"; then
		zip $COMPRESS $UPDATE "$PACKNAME" $(cygcheck -l $(apt-cyg depends $PACKAGES|sed 's/ > /\n/g'|sort|uniq|grep -Evi "$(sed 's/^/\^/; s/ /\$|\^/g; s/$/\$/' <<< "$PACKAGES")"|grep -Evi '^base-files$|^bash$|^cygwin$|^openssh$|^xorg-server$|^grep$')|sed 's/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g')
	else
		zip $COMPRESS $UPDATE "$PACKNAME" $(cygcheck -l $(apt-cyg depends $PACKAGES|sed 's/ > /\n/g'|sort|uniq|grep -Evi "$(sed 's/^/\^/; s/ /\$|\^/g; s/$/\$/' <<< "$PACKAGES")")|sed 's/\/usr\/bin\//\/bin\//g; s/\/usr\/lib\//\/lib\//g')
	fi
fi
}

function completedf {
echo; echo All threads completed.
du -sh "$PACKNAME"{,.zip,.mxt3} 2>/dev/null
}

mxtext
mxtf
standalonef
packagef
dependenciesf
completedf
