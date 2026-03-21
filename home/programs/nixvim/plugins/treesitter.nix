{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = false;
        };
        indent.enable = true;
      };
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        # languages
        bash
        c
        dockerfile
        go
        gomod
        gosum
        html
        json
        jsonc
        just
        lua
        markdown
        markdown_inline
        nix
        python
        rust
        sql
        yaml

        # foundational / support
        comment
        diff
        git_config
        git_rebase
        gitcommit
        gitignore
        query
        regex
        toml
        vim
        vimdoc
      ];
    };
  };
}
