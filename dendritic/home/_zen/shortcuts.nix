#   jq -c '.shortcuts[] | {id, key, keycode, action}' ~/.config/zen/<profile>/zen-keyboard-shortcuts.json | fzf
# Or inspect the input field in Settings → Keyboard Shortcuts.
[
  {
    # Ctrl+Alt+S → toggle compact mode
    id = "zen-compact-mode-toggle";
    key = "s";
    modifiers = { control = true; alt = true; };
  }
  # {
  #   id = "key_savePage";
  #   key = "s";
  #   modifiers = { control = true; };
  # }
  {
    # Disable Ctrl+Q to prevent accidental browser quits
    id = "key_quitApplication";
    disabled = true;
  }
]

# TODO: add more of these...
