# TODO

- [ ] secondary round of installations:
  - [ ] yazi (terminal file explorer, useful for niri?)
  - [ ] lazygit
  - [ ] direnv (equivalent to mise?) - look into devshells and how this plays into it
  - [ ] delta (diff for git) - going to see if I feel like I really need this
  - [ ] mergiraf (merge utility for git)
  - [x] bitwarden-desktop (there's also bitwarden tool for rofi)
  - [ ] github's cli
  - [ ] juijitsu (git replacement)
  - [ ] tailscale
  - [ ] tldr (when you just want examples instead of paragraphs from man-pages)
- [ ] fix fastfetch logo misalignment when printed from fish
  - seems like a ghostty or fish issue since it doesn't happen on subsequent splits or tabs
- [ ] helix config for remembering where last left in file?
  - if/when https://github.com/helix-editor/helix/pull/9143 gets merged or rebase and compile myself
- [ ] ghostty keyboard shortcuts e.g. go to left split
- [ ] hide certain applications from desktop (see omarchy repo as an example) e.g.
  - btop
  - helix
  - xterm
  - web (gnome default browser) - there's nix settings that allow for doing this
- [ ] something is adding the following packages that should be removed (can be seen in environment.systemPackages in repl)
  - alacritty
  - foot
- [ ] unlock keyring on login?
  - likely can't be done w/ autologin enabled
- [ ] setup firewall
  - skipping since this isn't laptop but will have to revisit when adding my laptop to this configuration
- [ ] was getting an issue when swayidle was added as a package where it would crash but works without it. Unsure why?
- [ ] kind of long boot time from pressing enter in gdm to seeing niri, black screen for a bit 
- [ ] use app switcher next niri release instead of just focusing previous window
- [ ] setup mozilla vpn but consider just using mulvad directly
- Noctalia issues / config
  - [x] Track configuration in `~/.flake`
  - [x] Audio tray icon doesn't work correctly when on my sony headphones
  - [x] Widget that opens when clicking the date/time tray icon still displaying 24 hour clock
    - may be fixed already
  - [x] Screen recording not working, issue involved doing something with the intel integrated graphics stuff
  - [x] Need to set up wallpaper
  - [x] decide whether to switch to noctalia's lock screen or keep using hyprlock
  - [ ] add calendar events support, see noctalia docs
- [ ] collect a shortcut cheatsheet
  - include gmail shortcuts
- [ ] configure a way in helix to delete/yank multiple lines and then paste as a single block
  - see https://github.com/helix-editor/helix/discussions/8601
- [ ] determine a way to see keyboard and mouse battery levels
- [x] keyboard media keys not working

## Keyboard Shortcuts

- [x] Mod + Tab - go to previous focused window
- [ ] Ctrl + Tab - go to previous focused window of the same application
- [ ] ??? - dismiss notification
- [x] Mod + Space - Application Launcher

## Debugging Mouse Cursor Stuttering

Solution (still proving): Unplug and plug it back in

1. Keep this running in a terminal:
   `sudo , libinput debug-events --show-keycodes`
2. In another terminal, watch Niri logs:
   `journalctl --user -u niri.service -f`
3. When stutter occurs, check:
  - Did libinput show any gaps or errors?
  - Did Niri log any frame drops or warnings?
  - Any kernel messages: `sudo dmesg | tail -20`

## Completed / Archived

- [x] set up niri
- [x] copy useful aliases from cachyos's fish config
- [x] discord tray icon? (for gnome)
- [x] fix zoxide, created an alias for `z` but may have not been the right way to initialize
- [x] firefox configs
  - [x] log into firefox account
  - [x] configure firefox w/ sidebery
  - [x] style userChrome.css
  - [x] style homepage with userContent.css
  - [x] set kagi as search engine in firefox
- [x] git init NixOS configuration as-is
- [x] get claude-code installed
- [x] convert configuration to using flakes
- [x] setup home-manager
- [x] copy some system configuration
- [x] figure out how to get ~/.config to be managed by nixos
- [x] first round of installations:
    - [x] ghostty
    - [x] fastfetch
    - [x] fish
    - [x] fzf
    - [x] ripgrep
    - [x] fd
    - [x] eza
    - [x] bat
    - [x] zoxide
    - [x] helix
    - [x] starship
    - [x] btop
- [x] setup a nerd font
- [x] configure fish, including w/ starship
- [x] setup configuration for ghostty
- [x] set default git editor to helix
- [x] set default shell to fish
- [x] figure out if configuration like keypress delay is something that goes into nix config
- [x] configure git that's tracked by nixos to do the following
    - default branch name to be `main`
    - sets user.name and user.email
    - aliases, diffs, etc
- [x] set up accounts
  - [x] discord (try vesktop?)
  - [x] spotify (try spotify-tui?)
- [x] setup programming languages
  - [x] erlang
  - [x] elixir
  - [x] gleam
  - [x] zig
- Niri issues / config
  - [x] swayidle / swaylock
    - switched to hypridle / hyprlock as systemd services
    - [x] switched back to swayidle but its not working
    - [x] hyprlock preventing suspend, logging in then suspends the system
  - [x] better styling of hyprlock, use omarchy's as a guide? 
  - [x] use niri-switch or niriswitcher instead of just focusing previous window
    - wait for next release of niri instead
  - [x] cursor size and theme issue
    - ended up adding adwaita icons, not sure if that's what I want though
    - still don't know where the icons are installed either
  - [x] gnome keyring
  - [x] xdg-desktop-portal-gtk (and -gnome)
  - [x] polkit_gnome
    - [x] test via `systemctl --user status polkit-gnome-authentication-agent-1`
