
######################################################################################################
# If no SSH agent is already running, start one now                                                  #
# Re-use sockets so we never have to start more than one session                                     #
# Based on http://www.electricmonk.nl/log/2012/04/24/re-use-existing-ssh-agent-cygwin-et-al/         #
# Modified for cygwin-portable-installer from https://github.com/vegardit/cygwin-portable-installer  #

export SSH_AUTH_PATH=~/.agentssh
export SSH_AUTH_KEY=~/.ssh/id_dsa
export SSH_AUTH_SOCK=$SSH_AUTH_PATH/.ssh-socket
  if ! ssh-add -l >/dev/null 2>&1; then
  rm -rf $SSH_AUTH_PATH; mkdir $SSH_AUTH_PATH
  rm -rf $SSH_AUTH_SOCK
  ssh-agent -a $SSH_AUTH_SOCK >| $SSH_AUTH_PATH/.ssh-script
  source $SSH_AUTH_PATH/.ssh-script
  echo $SSH_AGENT_PID >| $SSH_AUTH_PATH/.ssh-agent-pid
  rm -rf $SSH_AUTH_PATH/.ssh-script
    if [ -f $SSH_AUTH_KEY ]; then
    ssh-add $SSH_AUTH_KEY
    fi
fi

######################################################################################################
