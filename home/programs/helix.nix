{pkgs, ...}: {
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
              ":sh rm -f /tmp/unique-file"
              ":insert-output ${pkgs.yazi}/bin/yazi \"%{buffer_name}\" --chooser-file=/tmp/unique-file"
              ":sh printf \"\x1b\[?1049h\x1b\[?2004h\" > /dev/tty"
              ":open %sh{cat /tmp/unique-file}"
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
        # rust-analyzer = {
        #   command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        #   config = {
        #     check.command = "clippy";
        #   };
        # };
        vscode-langservers-extracted = {
          command = "${pkgs.vscode-langservers-extracted}/bin/vscode-json-language-server";
          args = ["--stdio"];
        };
        marksman = {
          command = "${pkgs.marksman}/bin/marksman";
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
          language-servers = ["ruff"];
          formatter = {
            command = "${pkgs.ruff}/bin/ruff";
            args = ["check" "fix"];
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
          language-servers = ["marksman"];
        }
      ];
    };
  };
}
