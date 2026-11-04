{ ... }: {
  programs.bottom = {
    enable = true;
    settings = {
      avg_cpu = true;
      temperature_type = "f";
      dot_marker = false;
    };
  };
}
