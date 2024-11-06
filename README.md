# Bait

Form input for [Fish](https://fishshell.com/), 
similar to [Gum](https://github.com/charmbracelet/gum).

## Installation

To install with [Fisher](https://github.com/jorgebucaran/fisher), use

```fish
fisher install tim-harding/bait
```

## Development

Use [stow](https://www.gnu.org/software/stow/manual/stow.html) to create symlinks in your Fish config directory. This command needs to be run whenever you add a new file. 

```fish
stow . --no-folding --restow --target ~/.config/fish/
```
