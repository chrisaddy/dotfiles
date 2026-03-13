{ ... }:

{
  programs.nixvim = {
    plugins.neogit = {
      enable = true;
      settings = {
        commit_editor = { kind = "floating"; };
        commit_select_view = { kind = "floating"; };
        preview_buffer = { kind = "floating"; };
        popup = { kind = "floating"; };
        merge_editor = { kind = "floating"; };
        log_view = { kind = "floating"; };
        description_editor = { kind = "floating"; };
        rebase_editor = { kind = "floating"; };
        reflog_view = { kind = "floating"; };
        integrations = { fzf_lua = true; };
      };
    };

    keymaps = [
      { mode = "n"; key = "<leader>gg"; action = "<cmd>Neogit<cr>"; options.desc = "git"; }
    ];
  };
}
