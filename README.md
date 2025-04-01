# Dotsis

Got [frustrated](https://github.com/moukle/.nix/tree/battlestation) of [NixOS](https://nixos.org/) and went back to Arch / [CachyOS](https://github.com/cachyos).
Still wanted a setup where I could hit one command on a fresh install and be set again.

## Packages

Packages are defined in `.setup/packages.sh`.
They are grouped in a way that allows picking individual sections, which is extremely useful when using environments like WSL.

[Stow](https://www.gnu.org/software/stow/) will symlink these dotfiles:

```shell
$ eza --tree --level=2 .

.
├── cli
│  ├── neovim         # editor
│  ├── python-pywal   # color templating
│  ├── starship       # prompt
│  ├── yazi           # file manager
│  └── zsh            # shell
├── gaming
│  └── ddnet          # best game
├── gui
│  ├── code           # editor
│  ├── kitty          # terminal
│  ├── zathura        # pads
│  └── zed-editor     # editor
└── wm
   ├── anyrun-git     # runner
   ├── dunst          # notifications
   ├── hyprland       # window manager
   ├── matugen-bin    # managing colors
   ├── niri-git       # portals not working
   └── waybar         # bar
```

## Install

To install, run:

```shell
cd .setup
./setup.sh
```

This will guide you through the installation thanks to [gum](https://github.com/charmbracelet/gum) 🪄.

> [!CAUTION]
> Currently only working with Arch based systems (`pacman`)

## Extra

- Firefox [Theme](https://github.com/artsyfriedchicken/EdgyArc-fr)
- Zen Transparency: [css](https://github.com/sameerasw/my-internet) [mod](https://zen-browser.app/mods/642854b5-88b4-4c40-b256-e035532109df/)
