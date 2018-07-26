# linuxShortcuts

## Pacman
### aur
Just a simple and fast shortcut to install aur packages using aurman with no confirmation.

**Recommended**: include in your `~/.bashrc` the following line: `alias aur='source ~/linuxShortcuts/Pacman/aur'`

**Usage**: find your package on aur website and just type `aur name-of-package`.

**Example**: for `visual-studio-code-bin` just type `aur visual-studio-code-bin`. It will ask for your root password and it will install it with all dependencies.


### updateRepositories.sh
A basic script to update the original packages with Pacman and aurman


## apt-get
### update.sh
A basic script to update your packages with apt-get
