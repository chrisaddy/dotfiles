local function init()
  require 'addy.vim'.init()
  require 'addy.packer'.init()
end

return {
  init = init,
}
