{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold #9ece6a)";
        error_symbol = "[➜](bold #f7768e)";
      };

      directory = {
        style = "bold #7aa2f7";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "bold #bb9af7";
        symbol = " ";
      };

      git_commit.disabled = true;

      git_status = {
        style = "bold #e0af68";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = "!";
        staged = "+";
        untracked = "?";
      };

      python = {
        style = "bold #7aa2f7";
        symbol = " ";
      };

      rust = {
        style = "bold #f7768e";
        symbol = " ";
      };

      nodejs = {
        style = "bold #9ece6a";
        symbol = " ";
      };

      lua = {
        style = "bold #7dcfff";
        symbol = " ";
      };

      nix_shell = {
        style = "bold #7aa2f7";
        symbol = " ";
      };

      cmd_duration = {
        style = "bold #565f89";
        min_time = 2000;
      };

      username.disabled = true;
      hostname.disabled = true;
      gcloud.disabled = true;
      aws.disabled = true;
    };
  };
}
