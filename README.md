# cygwin-extras
Enhancements / addons for Cygwin-like environments


## [PSSH (ParallelSSH)](https://github.com/zhubanRuban/cygwin-extras/blob/master/pssh)

Parallel SSH tool written in bash, specially for CygWin

### Installation
```
wget -O /usr/local/bin/pssh https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/pssh
chmod +x /usr/local/bin/pssh
```


## [PSCP (ParallelSCP)](https://github.com/zhubanRuban/cygwin-extras/blob/master/pscp)

Parallel SCP tool written in bash, specially for CygWin

### Installation
```
wget -O /usr/local/bin/pscp https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/pscp
chmod +x /usr/local/bin/pscp
```


## [SSH agent tweak](https://github.com/zhubanRuban/cygwin-extras/blob/master/ssh-agent-tweak)

To remember / reuse ssh key password and share between termnals

### Installation for single user

- append function to your .bashrc
```
wget -qO- https://github.com/zhubanRuban/cygwin-extras/raw/master/ssh-agent-tweak >> ~/.bashrc
```
- add `AddKeysToAgent yes` to ~/.ssh/config

### Installation for all users

- download to /etc/profile.d/
```
wget -O /etc/profile.d/ssh-agent-tweak.sh https://github.com/zhubanRuban/cygwin-extras/raw/master/ssh-agent-tweak
```
- add `AddKeysToAgent yes` to /etc/ssh_config

> Created specially for CygWin+ConEmu portable installer: https://github.com/zhubanRuban/cygwin-portable

### Sources

- [Auto-launching ssh-agent on Git for Windows](https://help.github.com/en/articles/working-with-ssh-key-passphrases#auto-launching-ssh-agent-on-git-for-windows)
- [SSH key management and ssh-agent setup](https://komyounity.com/upravlenie-kluchami-ssh-i-nastroyka-ssh-agent/)


## [Custom .inputrc](https://github.com/zhubanRuban/cygwin-extras/blob/master/inputrc-custom)

Makes Ctrl+Left and Ctrl+Right move cursor by words in local console (like in Linux systems)

### How to use:

Append to your .inputrc
```
wget -qO- https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/inputrc_custom >> ~/.inputrc
```


## [colours](https://github.com/zhubanRuban/cygwin-extras/blob/master/colours)

This script shows available colour codes


## [whois tweak](https://github.com/zhubanRuban/cygwin-extras/blob/master/whois-tweak)

As of 2017, whois does not show contact details in the output. This funtion allows to return this functionality.
Based on [TinyApps_Org's tweak](https://www.reddit.com/r/commandline/comments/6taq3k/why_is_whois_showing_no_registrant_information/dptii8b)

### How to use:

Append to your .bashrc
```
wget -qO- https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/whois-tweak >> ~/.bashrc
```
