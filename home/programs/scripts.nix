{ pkgs, lib, ... }:
let
  # Arch packages that genuinely cannot come from Nix, kept declarative so the
  # set has an owner instead of drifting as hand-run `pacman -S` calls.
  #
  # The bar for adding to this list is "pacman's own dependency graph or the
  # base system needs it". An ordinary CLI tool belongs in home/default.nix
  # instead — Nix wins on PATH, so a pacman copy is only dead weight.
  #
  # `base-devel` is a group, which covers gcc/m4/pkgconf; paru builds AUR
  # packages with it, so it cannot be dropped for the Nix toolchain.
  archSystemPackages = [
    "base"
    "base-devel"
    "sudo"
    "openssh"
    "less"
    "vim" # rescue editor: survives a broken Nix profile
    "git" # paru clones AUR repos with it
    "bubblewrap" # glycin (system GTK image loading) links against it
    "paru"
  ];
  # `update` and `exevm` used to be a zsh alias and a zsh function. As real
  # scripts on PATH they work from nushell too, without either shell needing to
  # know about the other. A nu `def` calling `zsh -lc update` cannot work: -lc
  # is non-interactive, so .zshrc (where Home Manager puts aliases and
  # functions) is never read.
  update = pkgs.writeShellApplication {
    name = "update";
    runtimeInputs = with pkgs; [
      git
      nix
      nh
      coreutils
    ];
    text = ''
      cd "$HOME/dotfiles"

      case "$(uname)" in
        Darwin) platform=darwin ;;
        *)      platform=linux  ;;
      esac

      git pull

      # Arch's system layer is outside Nix's reach, so upgrade it too. paru
      # covers the AUR as well and calls sudo itself; plain pacman does not.
      # Passing the package list to -Syu makes the upgrade and the
      # ensure-installed a single transaction.
      if command -v pacman >/dev/null 2>&1; then
        echo "==> Updating Arch system packages"
        if command -v paru >/dev/null 2>&1; then
          paru -Syu --needed ${lib.concatStringsSep " " archSystemPackages}
        else
          sudo pacman -Syu --needed ${lib.concatStringsSep " " archSystemPackages}
        fi
      fi

      nix flake update nixpkgs
      nh home switch . -c "$(whoami)@$platform"
      nh clean all
      git add -A
      # A clean tree is not a failure; skip the commit and still push whatever
      # is already local.
      git diff --cached --quiet || git commit -m 'update'
      git push
    '';
  };

  # exe.dev VM: create, bootstrap dotfiles on it, connect. Not to be confused
  # with bootstrap.sh, which configures the machine it runs on.
  exevm = pkgs.writeShellApplication {
    name = "exevm";
    runtimeInputs = with pkgs; [
      openssh
      jq
      coreutils
    ];
    text = ''
      vm_name="''${1:-dotfiles-vm}"
      dotfiles_repo="https://github.com/chrisaddy/dotfiles.git"

      echo "Creating VM '$vm_name'..."
      ssh exe.dev new --name="$vm_name"

      echo "Waiting for VM to be ready..."
      while true; do
        vm_status=$(ssh exe.dev ls --json | jq -r ".vms[] | select(.vm_name==\"$vm_name\") | .status")
        if [ "$vm_status" = "running" ]; then
          break
        fi
        echo "  status: $vm_status — waiting..."
        sleep 3
      done
      echo "VM is running!"

      echo "Cloning dotfiles and running bootstrap..."
      # $HOME is escaped so it expands on the VM; $dotfiles_repo is deliberately
      # expanded here, which is what SC2029 warns about.
      # shellcheck disable=SC2029
      ssh "$vm_name.exe.xyz" "git clone $dotfiles_repo \"\$HOME/dotfiles\" && cd \"\$HOME/dotfiles\" && bash bootstrap.sh"

      echo ""
      echo "✅ Setup complete! Connecting to $vm_name..."
      echo ""
      ssh "$vm_name.exe.xyz"
    '';
  };
in
{
  home.packages = [
    update
    exevm
  ];
}
