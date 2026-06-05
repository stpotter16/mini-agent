{
    description = "Dev environment for Coin";

    inputs = {
      flake-utils.url = "github:numtide/flake-utils";

      # 1.25.2 release
      go-nixpkgs.url = "github:NixOS/nixpkgs/01b6809f7f9d1183a2b3e081f0a1e6f8f415cb09";

    };

    outputs = {
      self,
      flake-utils,
      go-nixpkgs,
    } @inputs:
      flake-utils.lib.eachDefaultSystem (system: let
        gopkg = go-nixpkgs.legacyPackages.${system};
        go = gopkg.go_1_25;
      in {
        devShells.default = gopkg.mkShell {
            packages = [
              gopkg.gotools
              gopkg.gopls
              gopkg.go-outline
              gopkg.gopkgs
              gopkg.gocode-gomod
              gopkg.godef
              gopkg.golint
              go
              sqlite
              litestream
              shellcheck
              sqlfluff
              nodejs
              flyctl
            ];

            shellHook = ''
              PROJECT_NAME="$(basename "$PWD")"
              export GOPATH="$HOME/.local/share/go-workspaces/$PROJECT_NAME"
              export GOROOT="${go}/share/go"

              go version
              echo "node" "$(node --version)"
              echo "npm" "$(npm --version)"
              echo "npx" "$(npx --version)"
              fly version | cut -d ' ' -f 1-3
              echo "sqlite" "$(sqlite3 --version | cut -d ' ' -f 1-2)"
              echo "litestream" "$(litestream version)"
              echo "shellcheck" "$(shellcheck --version | grep '^version:')"
              sqlfluff --version
            '';
        };
      });
}
