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
          name = "python";
          roots = [
            "pyproject.toml"
            "requirements.txt"
          ];
          scope = "source.python";
          language-servers = [
            "ruff"
            "pyright"
          ];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = ["format" "--line-length" "88" "-"];
          };
          # debugger = {
          #   command = "${pkgs.}."
          # };
          auto-format = true;
        }
        {
          name = "rust";
          scope = "source.rust";
          language-servers = [
            "rust-analyzer"
          ];
          # formatter = {
          #   command = "${pkgs.cargo}/bin/cargo";
          #   args = ["fmt"];
          # };
          auto-format = true;
          roots = ["Cargo.toml"];
        }
      ];
    };
    settings = {
      theme = "tokyonight_moon";
      editor = {
        auto-save = {
          focus-lost = true;
          after-delay = {
            enable = true;
            timeout = 50;
          };
        };
        end-of-line-diagnostics = "hint";
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
        "[.b" = ":buffer-previous";
        "].b" = ":buffer-next";
        Z.Z = ":wq!";
      };
    };
    ignores = [".stack-work" "__pycache__"];
    extraPackages = with pkgs; [
      # haskell
      haskell-language-server
      # nix
      nil
      nixd
      # python
      ruff
      pyright
      # rust
      rust-analyzer
    ];
  };
}
