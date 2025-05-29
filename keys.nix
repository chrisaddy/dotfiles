let
  keys = {
    m4 = "hello";
    aion = "world";
  };
in
  keys
  // {
    admins = [keys.m4];
    all = builtins.attrValues keys;
  }
