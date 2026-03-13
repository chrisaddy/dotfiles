{ ... }:

{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
    };

    extraConfigLua = ''
      local function toggle_zellij_menu()
        if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
          vim.notify("Not running inside Zellij", vim.log.levels.WARN)
          return
        end
        vim.fn.system({
          "zellij", "action", "launch-or-focus-plugin",
          "--floating", "--move-to-focused-tab", "zellij:session-manager",
        })
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to open Zellij menu", vim.log.levels.ERROR)
        end
      end

      local function rename_zellij_tab()
        if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
          vim.notify("Not running inside Zellij", vim.log.levels.WARN)
          return
        end
        local name = vim.fn.input("Rename tab to: ")
        if name == nil or name == "" then return end
        vim.fn.system({ "zellij", "action", "rename-tab", name })
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to rename Zellij tab", vim.log.levels.ERROR)
        end
      end

      local function reload_zellij_config()
        if vim.env.ZELLIJ == nil or vim.env.ZELLIJ == "" then
          vim.notify("Not running inside Zellij", vim.log.levels.WARN)
          return
        end
        local config_path = vim.fn.expand("~/.config/zellij/config.kdl")
        vim.fn.system({ "touch", config_path })
        if vim.v.shell_error ~= 0 then
          vim.notify("Failed to reload Zellij config", vim.log.levels.ERROR)
          return
        end
        vim.notify("Reloaded Zellij config")
      end

      require("which-key").add({
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps" },
        { "<leader>tt", toggle_zellij_menu, desc = "Toggle Zellij menu" },
        { "<leader>r", rename_zellij_tab, desc = "Rename Zellij tab" },
        { "<C-r>", reload_zellij_config, desc = "Reload Zellij config" },
        { "<leader>f", group = "find" },
        { "<leader>n", group = "notes" },
        { "<leader>nt", group = "todos" },
      })
    '';
  };
}
