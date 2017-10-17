# cygwin-extras
Enhancements for Cygwin-like environments

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

## [Re-use SSH agent](https://github.com/zhubanRuban/cygwin-extras/blob/master/re-use-ssh-agent)

By default, Cygwin asks for SSH key password on every SSH login

This code will re-use existing SSH agent for every new Cygwin window

Based on [re-use-existing-ssh-agent-cygwin-et-al](http://www.electricmonk.nl/log/2012/04/24/re-use-existing-ssh-agent-cygwin-et-al/)

Modified for [cygwin-portable-installer](https://github.com/zhubanRuban/ConCygSys)

### How to use:

Append to your .bashrc

Can be done in the following way:
```
wget -O- https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/re-use-ssh-agent >> /path/to/your/.bashrc
```
Copy your SSH private and public keys to .ssh folder

Launch console

Run `ssh-add`, this will parse existing SSH keys in .ssh folder, if anything found - you will be prompted for key password. Keep current console open to use SSH key for all newly created console windows.

### Configuration:

**SSH_AUTH_PATH**
- a path where SSH agent will store its tmp files, moved to separate folder in $HOME for convenience
- *default*: ~/.agentssh

> **Make sure "Kill ssh-agent with ConEmu" option is switched off in ConEmu settings for better experience**

**Also see updated version of this tweak below:**

## [SSH agent tweak](https://github.com/zhubanRuban/cygwin-extras/blob/master/ssh-agent-tweak)

A new version of [re-use-ssh-agent](https://github.com/zhubanRuban/cygwin-extras#re-use-ssh-agent)

Based on [auto-launching-ssh-agent-on-msysgit](https://help.github.com/articles/working-with-ssh-key-passphrases/#auto-launching-ssh-agent-on-msysgit)

An attempt to simulate ssh-agent behaviour like on desktop Linux, e.g. SSH key password asked only once upon ssh or scp execution and stored until next reboot. Modified for CygWin+ConEmu portable build: https://github.com/zhubanRuban/ConCygSys

> **Make sure "Kill ssh-agent with ConEmu" option is switched off in ConEmu settings for better experience**

## [Custom .bashrc](https://github.com/zhubanRuban/cygwin-extras/blob/master/bashrc_custom)

- tiny and functional command prompt:

`user@host path $` - also automatically sets host as terminal title

- aliases for ls and grep

### How to use:

Append to your .bashrc

Can be done in the following way:
```
wget -O- https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/bashrc_custom >> /path/to/your/.bashrc
```

## [Custom .inputrc](https://github.com/zhubanRuban/cygwin-extras/blob/master/inputrc_custom)

Makes Ctrl+Left and Ctrl+Right move cursor by words in local console (like in Linux systems)

### How to use:

Append to your .inputrc

Can be done in the following way:
```
wget -O- https://raw.githubusercontent.com/zhubanRuban/cygwin-extras/master/inputrc_custom >> /path/to/your/.inputrc
```
