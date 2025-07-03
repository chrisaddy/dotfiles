let-env PATH = ($env.PATH | append {
  "/opt/homebrew/bin"
  "$OME/.cargo/bin"
}
