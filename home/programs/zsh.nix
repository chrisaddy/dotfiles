{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      vim = "nvim";
      ls = "exa -la";
      ccc = "claude --dangerously-skip-permissions";
      update = "pushd $HOME/dotfiles && git pull && nh home switch . -c $(whoami)@$(if [ $(uname) = Darwin ]; then echo darwin; else echo linux; fi) && nh clean all && git add -A && git commit -m 'update' && git push; popd";
    };

    initContent = ''
      export PATH=$HOME/.local/bin:$PATH

      # Carapace completions
      export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
      zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
      source <(carapace _carapace)

      # exevm — spin up a new exe.dev VM, bootstrap dotfiles on it, and connect
      # Usage: exevm [vm-name]
      # (not to be confused with bootstrap.sh, which configures the machine itself)
      exevm() {
        local vm_name="''${1:-dotfiles-vm}"
        local dotfiles_repo="https://github.com/chrisaddy/dotfiles.git"

        echo "Creating VM '$vm_name'..."
        ssh exe.dev new --name="$vm_name"

        echo "Waiting for VM to be ready..."
        while true; do
          local vm_status
          vm_status=$(ssh exe.dev ls --json | jq -r ".vms[] | select(.vm_name==\"$vm_name\") | .status")
          if [[ "$vm_status" == "running" ]]; then
            break
          fi
          echo "  status: $vm_status — waiting..."
          sleep 3
        done
        echo "VM is running!"

        echo "Cloning dotfiles and running bootstrap..."
        ssh "$vm_name.exe.xyz" "git clone $dotfiles_repo ~/dotfiles && cd ~/dotfiles && bash bootstrap.sh"

        echo ""
        echo "✅ Setup complete! Connecting to $vm_name..."
        echo ""
        ssh "$vm_name.exe.xyz"
      }
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
