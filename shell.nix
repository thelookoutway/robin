let
  sources = import ./nix/sources.nix;
  nixpkgs = import sources.nixpkgs {};
  mkBundlerAppDevShell = nixpkgs.callPackage (import sources.bundler-app-dev-shell) {};
in mkBundlerAppDevShell {
  buildInputs = with nixpkgs; [
    bundler
    libiconv
    pkg-config
    postgresql_10
    ruby
    zlib
  ];
}
