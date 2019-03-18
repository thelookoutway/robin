with import <nixpkgs> {};

let
  nixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d4559c372d99a84b6aec5d4b679e1248078bc44a.tar.gz";
    sha256 = "047q008613bldh041csp5g3bwsim8hnz0xh2i6zd25l0wvm6b5v7";
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
