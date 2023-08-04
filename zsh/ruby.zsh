export PATH="/opt/homebrew/opt/openssl@3/bin:$PATH"
export LIBRARY_PATH="$LIBRARY_PATH:/opt/homebrew/opt/openssl@3/lib/"
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@3)"
export PKG_CONFIG_PATH="$(brew --prefix openssl@3)/lib/pkgconfig"

source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh
source $(brew --prefix)/opt/chruby/share/chruby/auto.sh
