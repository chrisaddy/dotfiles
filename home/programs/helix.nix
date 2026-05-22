{pkgs, ...}: {
  xdg.configFile."ty/ty.toml".text = ''
    [rules]
    division-by-zero = "warn"
  '';

  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_macchiato";
      editor = {
        line-number = "relative";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        inline-diagnostics = {
          cursor-line = "warning";
        };
        indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 1;
        };
        lsp = {
          enable = true;
          auto-signature-help = true;
          display-messages = true;
        };
      };
      keys = {
        normal = {
          space = {
            l = {
              g = [":new" ":insert-output ${pkgs.lazygit}/bin/lazygit" ":buffer-close!" ":redraw"];
            };
            o = [
              ":sh rm -f /tmp/yazi-unique-file"
              ":insert-output ${pkgs.yazi}/bin/yazi \"%{buffer_name}\" --chooser-file=/tmp/yazi-unique-file"
              ":sh printf \"\x1b\[?1049h\x1b\[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/yazi-unique-file}"
              ":redraw"
            ];
            z = ":w";
          };
          Z = {
            Z = ":write-quit-all!";
          };
        };
      };
    };
    languages = {
      language-server = {
        nil = {
          command = "${pkgs.nil}/bin/nil";
        };
        vscode-langservers-extracted = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = ["--stdio"];
        };
        basedpyright = {
          command = "${pkgs.basedpyright}/bin/basedpyright-langserver";
          args = ["--stdio"];
        };
        ruff = {
          command = "${pkgs.ruff}/bin/ruff";
          args = ["server"];
        };
        ty = {
          command = "${pkgs.ty}/bin/ty";
          args = ["server"];
        };
      };
      language = [
        {
          name = "nix";
          language-servers = ["nil"];
          auto-format = true;
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
        }
        {
          name = "rust";
          # language-servers = ["rust-analyzer"];
          auto-format = true;
          roots = [
            "Cargo.lock"
            "Cargo.toml"
          ];
          formatter = {
            command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          };
        }
        {
          name = "python";
          language-servers = ["basedpyright" "ruff" "ty"];
          auto-format = true;
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = ["format" "-"];
          };
        }
        {
          name = "json";
          auto-format = true;
          language-servers = ["vscode-langservers-extracted"];
        }
        {
          name = "markdown";
          auto-format = true;
          soft-wrap.enable = true;
        }
      ];
    };
  };
}
