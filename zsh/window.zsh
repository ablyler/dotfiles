# From http://dotfiles.org/~_why/.zshrc and https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/termsupport.zsh
# for my purposes, i don't care about window title, just the tab title given to tmux,
function title() {
  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      print -Pn "\e]1;$1:q\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
    echoti tsl
    print -Pn "$1"
    echoti fsl
  fi
      fi
      ;;
  esac
}

function set_idle_title() {
  if (( ${+SSH_CLIENT} )); then
    title "%m:%18<..<%~%<<" # host + left truncated pwd
  else # local shell
    title "%25<..<%~%<<" #left truncated pwd
  fi
}

function set_title() { # called before a command is executed, code via oh-my-zsh
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|rake|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  if (( ${+SSH_CLIENT} )); then
    title "%m:$CMD"
  else # local shell
    title "$CMD"
  fi
}

# autoload -U add-zsh-hook
# add-zsh-hook precmd  set_idle_title
# add-zsh-hook preexec set_title
