local function init()
  vim.api.nvim_exec([[
    let g:autofmt_autosave = 1
    autocmd BufWritePre *.py execute ':Black'
  ]])

end

return {
  init = init
}
