## -- General --

# alias
alias python=python3
alias pip=pip3

complete -cf man
complete -cf sudo
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# extended CD 
shopt -s autocd
export CDPATH=.:~

HISTSIZE=
HISTFILESIZE=
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

# helps extracting various files
function extract() {
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2)  tar xjf    $1 ;;
        *.tbz2)     tar xjf    $1 ;;
        *.tar.gz)   tar xzf    $1 ;;
        *.tgz)      tar xzf    $1 ;;
        *.tar.xz)   tar xJf    $1 ;;
        *.tar)      tar xf     $1 ;;
        *.bz2)      bunzip2    $1 ;;
        *.gz)       gunzip     $1 ;;
        *.rar)      unrar x    $1 ;;
        *.zip)      unzip      $1 ;;
        *.Z)        uncompress $1 ;;
        *)          echo "cannot extract '$1'" ;;
        esac
    else
        echo "invalid file: '$1'"
    fi
}

## -- Git --

# cd back to git base directory
cdg() {
    t=`pwd`
    while ! [ -d .git ]; do
            cd ..
    done
    OLDPWD=$t
}

# helper function overwrite PS1 variable to show Git branch
function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\$(parse_git_branch)% "


## -- Security --

# tars and encrypts a directory with password (WIP)
function encdir() {
  tar -czvf $1.tar $1
  gpg -c $1.tar
}

# decrypts and untars a directory (WIP)
function decdir() {
  gpg -o ${1:0:-4} -d $1
  tar -zxvf ${1:0:-4}
}

# -- Docker -- 

# starts the docker-machine
function dmstart() {
  docker-machine start
  docker-machine env
  eval $(docker-machine env)
}

# starts an interactive docker container with maven tools, need to cd into /root first
function dmvn() {
  docker run -it -v $(pwd):/root maven /bin/bash
}


