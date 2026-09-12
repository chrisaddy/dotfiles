# Completion
autoload -Uz compinit
compinit

# Autosuggestions & syntax highlighting (pacman: zsh-autosuggestions, zsh-syntax-highlighting)
[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ] &&
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] &&
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls="exa -la"
alias lss="yazi"
alias ccc="claude --dangerously-skip-permissions"
alias zl='zellij attach $(zellij list-sessions --short | fzf)'
alias zk='zellij delete-session $(zellij list-sessions --short | fzf) --force'
# `update` and `exevm` live in ~/.local/bin as real scripts, so nushell gets them too.

export EDITOR=nvim
export VISUAL=nvim
export NPM_CONFIG_PREFIX="$HOME/.npm-global"

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH:$HOME/.cargo"

# Carapace completions
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# opam env for the default switch (compiler, dune, ocaml-lsp-server,
# ocamlformat). Guarded on ~/.opam so a machine that hasn't run
# `opam init` yet starts a clean shell. --safe keeps opam from rewriting
# any state just to print the env. Per-project switches still override
# this via the direnv hook below, which runs at precmd.
# Skipped inside devenv: an auto-activated devenv shell re-runs this file,
# and opam would prepend its switch ahead of the project's toolchain.
if [ -z "$DEVENV_ROOT" ] && command -v opam >/dev/null 2>&1 && [ -d "$HOME/.opam" ]; then
  eval "$(opam env --safe)"
fi

if command -v devenv >/dev/null 2>&1; then
  eval "$(devenv hook zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  _direnv_hook() {
    trap -- '' SIGINT
    eval "$(direnv export zsh)"
    trap - SIGINT
  }
  typeset -ag precmd_functions
  if (( ! ${precmd_functions[(I)_direnv_hook]} )); then
    precmd_functions=(_direnv_hook $precmd_functions)
  fi
  typeset -ag chpwd_functions
  if (( ! ${chpwd_functions[(I)_direnv_hook]} )); then
    chpwd_functions=(_direnv_hook $chpwd_functions)
  fi
fi

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# cd-on-exit yazi wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  local cwd
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

[ -f "$HOME/.secrets" ] && source "$HOME/.secrets"
