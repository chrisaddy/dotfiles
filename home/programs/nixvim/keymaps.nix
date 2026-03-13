{ ... }:

{
  programs.nixvim = {
    keymaps = [
      { mode = "n"; key = "gd"; action.__raw = "vim.lsp.buf.definition"; options.desc = "Go to definition"; }
      { mode = "n"; key = "K"; action.__raw = "vim.lsp.buf.hover"; options.desc = "Hover"; }
      { mode = "n"; key = "<C-k>"; action.__raw = "vim.lsp.buf.signature_help"; options.desc = "Signature help"; }
    ];
  };
}
