with import <nixpkgs> {};

let
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/7d141ec3269d34484fd1b98a8c67d9f71811ebe6.tar.gz";
    sha256 = "1xncgypvsxk87dr1ryjc3b2y4644g1036qkvbmi5qapk013c2x5i";
  }) {};

  ruby = nixpkgs.ruby_2_6;
  node = nixpkgs.nodejs-8_x;

in stdenv.mkDerivation rec {
  name = "fivegoodfriends";
  buildInputs = [
    ruby
    bundler
    node
    yarn
    direnv
    clang
    libxml2
    libxslt
    readline
    sqlite
    openssl
    libiconv
  ];

  shellHook = ''
    RUBY_VERSION=$(cat .ruby-version)
    mkdir -p .bundle/$RUBY_VERSION
    export GEM_HOME=$PWD/.bundle/$RUBY_VERSION
    export GEM_PATH=$GEM_HOME

    export LIBXML2_DIR=${pkgs.libxml2}
    export LIBXSLT_DIR=${pkgs.libxslt}

    mkdir -p $HOME/.npm
    export NPM_CONFIG_PREFIX=$HOME/.npm
  '';
}
