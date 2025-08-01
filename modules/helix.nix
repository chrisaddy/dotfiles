{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages = {
      language = [
        {
          name = "haskell";
          scope = "source.hs";
          auto-format = true;
        }

        {
          name = "nix";
          scope = "source.nix";
          language-servers = [
            "nil"
            "nixd"
          ];
          formatter = {
            command = "${pkgs.alejandra}/bin/alejandra";
          };
          auto-format = true;
        }
        {
          name = "ocaml";
          scope = "source.ml";
          language-servers = [
            "ocamllsp"
          ];
          formatter = {
            command = "${pkgs.ocamlformat}/bin/ocamlformat";
          };
          auto-format = true;
        }
        {
          name = "python";
          roots = [
            "pyproject.toml"
            "requirements.txt"
          ];
          scope = "source.python";
          language-servers = [
            "ruff"
            "basedpyright"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = ["format" "--line-length" "88" "-"];
          };
          auto-format = true;
        }
        {
          name = "rust";
          scope = "source.rust";
          language-servers = [
            "rust-analyzer"
          ];
          auto-format = true;
          roots = ["Cargo.toml"];
        }
      ];
    };
    settings = {
      theme = "base16_terminal";
      editor = {
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 50;
          };
        };
        end-of-line-diagnostics = "hint";
        file-picker = {
          hidden = false;
        };
        line-number = "relative";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "warning";
        };
        lsp = {
          display-messages = true;
          display-progress-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          insert = "bar";
        };
        indent-guides = {
          enable = true;
          character = "▏";
        };
        statusline = {
          mode = {
            normal = "normal";
            insert = "insert";
            select = "select";
          };
        };
        whitespace = {
          render = "all";
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
      };
      keys.normal = {
        Z.Z = ":write-quit-all!";
        H = ["extend_to_line_start" "yank_main_selection_to_clipboard"];
        L = ["extend_to_line_end" "yank_main_selection_to_clipboard"];
      };
    };
    ignores = [".stack-work" "__pycache__"];
    extraConfig = ''
      [keys.normal."["]
      b = ":buffer-previous"

      [keys.normal."]"]
      b = ":buffer-next"

    '';
    extraPackages = with pkgs; [
      # nix
      nil
      nixd
      # python
      ruff
      basedpyright
      # rust
      rust-analyzer
    ];
  };
}
