{ config, lib, ... }:
{
  programs.mise = {
    enable = true;

    # Off deliberately. HM's nushell integration runs `mise activate nu` at
    # build time, inside the Nix sandbox, and that script hard-codes the
    # sandbox's PATH (/homeless-shelter/..., stdenv store paths) into
    # `$env.PATH = ...`. Sourced from config.nu, it clobbered the PATH env.nu
    # had just built, so a fresh nu found neither `vim` nor `zoxide`.
    enableNushellIntegration = false;
  };

  # Generate the activation script at shell startup instead, from the real
  # PATH, into nu's vendor autoload dir (loaded after config.nu). mkAfter keeps
  # it behind the PATH setup in nushell.nix's extraEnv, and `^mise` resolves
  # through that PATH so a running shell survives `nh clean all`.
  programs.nushell.extraEnv = lib.mkIf config.programs.nushell.enable (
    lib.mkAfter ''
      let mise_autoload = ($nu.data-dir | path join "vendor" "autoload")
      mkdir $mise_autoload
      ^mise activate nu | save --force ($mise_autoload | path join "mise.nu")
    ''
  );
}
