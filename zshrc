alias ga='git add'
alias gck='git checkout'
alias gc='git commit'
alias gs='git status'
alias gpull='sshadd; git pull origin $(git_current_branch)'
alias gp='sshadd; git gc --auto; git push --all origin; git push --tags'
alias update='bash ~/Apps/linuxShortcuts/Pacman/updateRepositories.sh'
alias grep='grep --color=auto'
alias ls='ls -h --color=tty'
function sshadd()
{
	ssh-add -l > /dev/null || ssh-add
}

function le { "$1" | less }
function cd { builtin cd "$1"; ls --color=tty; echo "$PWD" }
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

# Enable tree view for kill completion
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'

#Docker-compose autocomplete para o Zsh
fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i

# Bruno - keychain - enable and manage ssh-agent
eval $(keychain --eval --quiet)

#GPG Key
export GPG_TTY=$(tty)
