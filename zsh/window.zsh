# copied from pure; modified to honor disable title updating
prompt_pure_set_title() {
  setopt localoptions noshwordsplit

  # Honor the disabled auto title flag
  [[ "$DISABLE_AUTO_TITLE" == "true" ]] && return

  # Emacs terminal does not support settings the title.
  (( ${+EMACS} || ${+INSIDE_EMACS} )) && return

  case $TTY in
    # Don't set title over serial console.
    /dev/ttyS[0-9]*) return;;
  esac

  # Show hostname if connected via SSH.
  local hostname=
  if [[ -n $prompt_pure_state[username] ]]; then
    # Expand in-place in case ignore-escape is used.
    hostname="${(%):-(%m) }"
  fi

  local -a opts
  case $1 in
    expand-prompt) opts=(-P);;
    ignore-escape) opts=(-r);;
  esac

  # Set title atomically in one print statement so that it works when XTRACE is enabled.
  print -n $opts $'\e]0;'${hostname}${2}$'\a'
}

# disable auto updating title
auto_title_disable() {
  export DISABLE_AUTO_TITLE="true"
  title "$PWD"
}

# enable auto updating title
auto_title_enable() {
  export DISABLE_AUTO_TITLE="false"
}

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
