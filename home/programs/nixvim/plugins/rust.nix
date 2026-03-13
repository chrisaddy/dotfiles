{ ... }:

{
  programs.nixvim = {
    plugins.rustaceanvim = {
      enable = true;
      settings = {
        tools = {
          hover_actions = {
            auto_focus = false;
          };
        };
        server = {
          auto_attach = true;
          default_settings = {
            rust-analyzer = {
              checkOnSave = true;
              cargo = {
                allFeatures = true;
              };
            };
          };
          on_attach.__raw = ''
            function(client, bufnr)
              vim.keymap.set("n", "<leader>ca", function()
                vim.cmd.RustLsp('codeAction')
              end, { buffer = bufnr, desc = "Rust code action" })
              vim.keymap.set("n", "<leader>dr", function()
                vim.cmd.RustLsp('debuggables')
              end, { buffer = bufnr, desc = "Rust debuggables" })
            end
          '';
        };
      };
    };
  };
}
