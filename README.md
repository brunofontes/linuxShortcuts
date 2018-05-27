# linuxShortcuts

## Arch-Manjaro 
### Aur.sh
This is not an automated script, but just a shorcut to `git clone` inside de Download folder, `makepkg -si` and delete the created structure.

**Recommended**: include in your `~/.bashrc` the following line: `alias aur='source ~/aur.sh'`

**Usage**: find your package on aur website and just type `aur name-of-package`.

**Example**: for `visual-studio-code-bin` just type `aur visual-studio-code-bin`. It will ask for your root password and it will install it with all dependencies.
