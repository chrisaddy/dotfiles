{ pkgs, lib, ... }:
let
  # Arch packages that genuinely cannot come from Nix, kept declarative so the
  # set has an owner instead of drifting as hand-run `pacman -S` calls.
  #
  # The bar for adding to this list is "pacman's own dependency graph or the
  # base system needs it". An ordinary CLI tool belongs in home/default.nix
  # instead — Nix wins on PATH, so a pacman copy is only dead weight.
  #
  # Every entry must resolve in the official repos: there is no AUR helper
  # here, so an AUR-only name makes `pacman -S` fail with "target not found"
  # and takes the whole update down with it.
  archSystemPackages = [
    "base"
    "base-devel" # the Arch base toolchain; gcc, m4 and pkgconf hang off it
    "sudo"
    "openssh"
    "less"
    # The rescue floor. A broken Nix profile takes hx and Nix's git with it,
    # and repairing the flake needs an editor and a way to reach the repo.
    "vim"
    "git"
    "bubblewrap" # glycin (system GTK image loading) links against it
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

      # Arch's system layer is outside Nix's reach, so upgrade it too. Passing
      # the package list to -Syu makes the upgrade and the ensure-installed a
      # single transaction. There is no AUR helper in the loop — everything
      # that used to justify one now comes from Nix.
      if command -v pacman >/dev/null 2>&1; then
        echo "==> Updating Arch system packages"
        sudo pacman -Syu --needed ${lib.concatStringsSep " " archSystemPackages}
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
