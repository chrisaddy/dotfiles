{ ... }:

{
  programs.nixvim = {
    plugins.trouble = {
      enable = true;
    };

    diagnostics = {
      virtual_text = true;
      signs = true;
      update_in_insert = false;
      underline = true;
      severity_sort = true;
      float = {
        focusable = false;
        style = "minimal";
        border = "rounded";
        source = "always";
        header = "";
        prefix = "";
      };
    };

    keymaps = [
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<cr>"; options.desc = "Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xX"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>"; options.desc = "Buffer Diagnostics (Trouble)"; }
      { mode = "n"; key = "<leader>xq"; action = "<cmd>Trouble qflist toggle<cr>"; options.desc = "Quickfix List (Trouble)"; }
    ];

    extraConfigLua = ''
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';
  };
}
