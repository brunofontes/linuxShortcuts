# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=/home/bruno/.oh-my-zsh
  export XDEBUG_CONFIG="idekey=VSCODE"

# Path to my personal npm file path
export PATH=~/.npm-global/bin:$PATH

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
#ZSH_THEME="pure"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git gitfast git-flow gitignore sudo docker composer autojump gnu-utils gpg-agent homestead laravel man thefuck ufw vagrant vim-interaction vscode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
 export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='vim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias ga='git add'
alias gch='git checkout'
alias gc='git commit'
alias gs='git status'
alias gpull='sshadd; git pull origin $(git_current_branch)'
alias gp='sshadd; git gc --auto; git push --all origin; git push --tags'
alias glog='git log --graph --oneline --decorate -n 10 --color'
alias update='bash ~/Apps/linuxShortcuts/Pacman/updateRepositories.sh'
alias grep='grep --color=auto'
alias ls='ls -h --color=tty'
alias la='ls -A --color=tty'
alias aur='aurman -S --noedit --noconfirm --color always'
alias cat='bat'
alias du='ncdu --color dark --exclude .git'
alias clearLogs='sudo find /var/log -mtime +30 -type f -delete'
alias vzsh='vim ~/.zshrc && source ~/.zshrc'
alias ssh='sshadd; /usr/bin/ssh'

function vagrant () {
   builtin cd ~/development/laravelHomestead && /usr/bin/vagrant $* && builtin cd -
}

function mkcd () { mkdir -p "$1" && builtin cd -P -- "$1" }
function sshadd() { ssh-add -l > /dev/null || ssh-add }
function le { "$1" | less }
function cd { echo; builtin cd "$1"; ls --color=tty; echo; echo PWD: "$PWD" }

function extract()    # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#Enable menu select
zstyle ':completion:*' menu select

# Enable tree view for kill completion
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'

#Docker-compose autocomplete para o Zsh
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Bruno - keychain - enable and manage ssh-agent
eval $(keychain --eval --quiet)

#GPG Key
export GPG_TTY=$(tty)

#Bruno - Enabling TheFuck
eval $(thefuck --alias)

#Bruno - To run Tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
        source /etc/profile.d/vte.sh
fi

#Bruno - Keep "LESS" content on screen when exit
export LESS="-XFR"
