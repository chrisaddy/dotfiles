#!/usr/bin/env nu

let system = 'you are an expert and nixos
this is my dotfile repo across multiple machines including linux and macos

please look at each file to understand the overall structure of the project,
and then you will be asked specific questions to improve the site.
'

let files = fd --type file
  | split row "\n"
  | filter {|file| $file !~ '.html|.nu|CNAME|404.md|README|flake'}
  | each {|file| $'
# <file>
#   <name>($file)</name>
#   (open $file)
# </file>'
}
  | reduce { |elt, acc| $acc + $elt }
  | clipboard copy
