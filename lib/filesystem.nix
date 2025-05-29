{lib, ...}: {
  collectNix = path:
    lib.filesystem.listFilesRecursive path
    |> lib.filter (lib.hasSuffix ".nix");
}
