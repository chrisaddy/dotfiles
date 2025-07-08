$env.JAVA_HOME = (/usr/libexec/java_home -v11)

$env.EDITOR = 'nvim'

alias .. = cd ..
alias vi = nvim
alias vim = nvim

$env.PATH = $env.PATH | append "/opt/homebrew/bin" | append $env.JAVA_HOME
