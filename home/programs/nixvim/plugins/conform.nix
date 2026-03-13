{ ... }:

{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        notify_on_error = true;
        notify_no_formatters = true;
        formatters_by_ft = {
          bash = [ "shellcheck" "shellharden" "shfmt" ];
          docker = [ "dockerfmt" ];
          go = [ "gofmt" ];
          html = [ "html_beautify" ];
          json = [ "jq" ];
          just = [ "just" ];
          lua = [ "stylua" "lua-format" ];
          markdown = [ "markdownlint-cli2" ];
          nix = [ "alejandra" "nixpkgs-fmt" ];
          python = [ "isort" "ruff" ];
          sql = [ "sqlfmt" ];
          yaml = [ "yamlfmt" "yq" ];
          "_" = [ "squeeze_blanks" "trim_whitespace" "trim_newlines" ];
        };
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
      };
    };
  };
}
