export PATH="$HOME/.composer/vendor/bin:/usr/local/share/npm/bin:/usr/local/opt/ruby/bin:$HOME/bin:/usr/local/bin:/usr/local/sbin:$ZSH/bin:$HOME/source/bin:$PATH"
if [[ -d /usr/local/opt/php56/bin ]]; # from homebrew, but brew --prefix is slow
then
  export PATH="/usr/local/opt/php56/bin:$PATH"
fi

# openjdk
export PATH="/usr/local/opt/openjdk/bin:$PATH"

# pipx
export PATH="$HOME/.local/bin:$PATH"

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

# go
export GOPATH="$HOME/source"
export PATH="$GOPATH/bin:$PATH"
