{
  # Bash is not the daily driver — nushell is, with zsh on the headless VMs.
  # It is managed anyway because it is the shell you *land in* when the login
  # shell breaks: `chsh` to a bad path, or a package manager deleting the shell
  # binary out from under you. An unmanaged bash means the stock Arch skeleton
  # with `PS1='[\u@\h \W]\$ '` and no session variables, which reads as
  # "starship is broken" when starship is fine.
  #
  # Enabling it is also what makes `programs.starship.enableBashIntegration`
  # (true by default) do anything: with no bash module, Home Manager writes no
  # .bashrc and the integration silently goes nowhere.
  programs.bash.enable = true;

  # HM's bash direnv hook bakes in an absolute store path, which breaks after a
  # rebuild + `nh clean all` deletes that derivation. zsh.nix installs a
  # $PATH-based hook instead; bash is a rescue shell that does not warrant the
  # same machinery, so it simply goes without.
  programs.direnv.enableBashIntegration = false;
}
