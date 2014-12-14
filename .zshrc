# use ~/.profile
source $HOME/.profile

# Libraries
source ~/github/my-zshrc/.virtualenv.zsh
source ~/github/my-zshrc/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


#[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

httpserver () {
    sleep 1 && open "http://localhost:$1/" &
    python -m SimpleHTTPServer $1 ${@:2}
}

clip_code (){

    local syntax=$1
    local theme_type=$2 # dark or light

    if [ "$theme_type" = "light" ]
    then
        local theme=fine_blue
    elif [ "$theme_type" = "dark" ]
    then
        local theme=zenburn
    elif [ -n "$theme_type" ]
    then
        local theme=$theme_type
    else
        echo "$0 <syntax> <dark|light|theme>"
        return 1
    fi

    plaintext
    pbpaste

    # convert
    #pbpaste | highlight --syntax=$syntax -O rtf --font-size 36 --font "Ubuntu Mono" --style $theme ${@:2} | pbcopy
    pbpaste | highlight --syntax=$syntax -O rtf --font-size 36 --font "Droid Sans Mono" --style $theme | pbcopy
}

man () {
    /usr/bin/man $@ | col -b | vim -R -c 'set ft=man nomod nolist' -
}

function git-conflict {
    vim -p $(git diff --name-only --diff-filter=U);
}

function gen_gitignore () {
    curl http://www.gitignore.io/api/$@ ; 
}


# convert the encoding of files to UTF-8
to_utf8 () {
    enca -L zh_TW -x UTF-8 $1;
}

# convert between zh_TW and zh_CN

sc2tc () {
    iconv -f UTF-8 -t GB2312 $1 | iconv -f GB2312 -t BIG-5 | iconv -f BIG-5 -t UTF-8 > $2;
}

tc2sc () {
    iconv -f UTF-8 -t BIG-5 $1| iconv -f BIG-5 -t GB2312 | iconv -f GB2312 -t UTF-8 > $2;
}

# change the names of two files.
swap_name () {
    temp_swap_filename="aslkdjasldjkas";
    if [ $# != 2 ] ; then
        echo "Please give only two filenames as arguments.";
    else
        mv $1 $temp_swap_filename;
        mv $2 $1;
        mv $temp_swap_filename $2;
        echo "$2 <--> $1";
    fi
}

appengine () {
    if [ $1 = "startproject" ]; then
        cp -r /usr/local/google_appengine/new_project_template ./$2 
    fi
}

git_branch() {
    git branch | grep "^\*" | tr -d "* "  2> /dev/null
}

plaintext() {
    pbpaste -Prefer txt | pbcopy
}

alias sharecity="actenv sharecity"
alias omgtt="actenv omgtt"


## Function to connect the instances in the internal cloud (PLSM Cloud)
connect_plsm_instance () {
    if [ $# -ne 1 ]; then
        echo "Usage: connect_plsm_instance <private ip>";
        echo "private ip: the private ip of the instance in the PLSM private cloud";
    fi

    ssh -t littleq@140.119.164.155 "ssh -i ~/.ssh/id_littleq-plsm ubuntu@$1"
}

## Function to check the ports are listening any ports on this machine
check_open_port () {
    sudo lsof -i -P | grep -i "listen"
}


#RPROMPT=#'%/'
#PROMPT='%{[36m%}%n%{[35m%}@%{[34m%}%M %{[33m%}%D %T  %{[32m%}%/ 
#%{[31m%}>>%{[m%}'


#. ~/.profile

#关于历史纪录的配置
# enhance Chinese supports for auto completion list
export LANG=en_US.UTF-8
# number of lines kept in history
export HISTSIZE=1000
# number of lines saved in the history after logout
export SAVEHIST=1000
# location of history
export HISTFILE=~/.zhistory
# append command to history file once executed
setopt INC_APPEND_HISTORY
# removed the duplicated history
setopt HIST_IGNORE_DUPS

#Disable core dumps
limit coredumpsize 0

#Emacs风格键绑定
bindkey -e
#设置DEL键为向后删除
bindkey "\e[3~" delete-char

#以下字符视为单词的一部分
WORDCHARS=';*?_-[]~=&!#$%^(){}<>'

bindkey ';5D' backward-word
bindkey ';5C' forward-word

#自动补全功能
setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE


# Completion caching
zstyle ':completion::complete:*' use-cache off
zstyle ':completion::complete:*' cache-path .zcache
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#Completion Options
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' completer _complete _prefix _correct _prefix _match _approximate
zstyle ':completion:*' verbose true

# Path Expansion
zstyle ':completion:*' expand-or-complete 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:*:*:default' menu yes select
zstyle ':completion:*:*:default' force-list always

if [ "$MACHINE_OS" = "macosx" ] ; then
else
	alias gdircolors="dircolors"
    if [ -f /etc/DIR_COLORS ] ; then
        eval $(gdircolors -b /etc/DIR_COLORS);
    else
        eval $(gdircolors -b);
    fi
fi

# GNU Colors 需要/etc/DIR_COLORS文件 否则自动补全时候选菜单中的选项不能彩色显示
#[ -f /etc/DIR_COLORS ] && eval $(gdircolors -b /etc/DIR_COLORS)
#[ -f /etc/DIR_COLORS ] && eval $(gdircolors -b)


fpath=($HOME/Dropbox/portableLibraries/zsh/completion $fpath)
fpath=(
    $HOME/github/zsh-completions/src
    $HOME/github/maven-zsh-completion
    $fpath)
# debugging gcloud zsh completion
fpath=($HOME/github/gcloud-zsh-completion/src $fpath)

autoload -U compinit compdef
compinit
compdef pkill=kill
compdef pkill=killall
compdef hub=git

export LSCOLORS='exfxbxdxcxegedabagacad'
export ZLSCOLORS="${LS_COLORS}"
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:processes' command 'ps -au$USER'

# Group matches and Describe
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d --\e[0m'
zstyle ':completion:*:messages' format $'\e[01;35m -- ^_^y %d --\e[0m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- O_O! No Matches Found --\e[0m'

#命令别名
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
if [ "$MACHINE_OS" = "ubuntu" ]; then
    alias ls="ls --color"
else
    alias ls='gls --color'
fi
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -al'
alias sl='ls'
alias grep='grep --color=auto'
alias back='tmux -2 attach'
alias q='exit'

# VIM aliases
alias vimsplit="vim -o"
alias vimvsplit="vim -O"
alias vimsp="vimsplit"
alias vimvsp="vimvsplit"
alias vimtab="vim -p"

# syntax highlight using cat
alias pcat=pygmentize
function pless() {
    pcat "$1" | less -R
}

if [ $MACHINE_OS = "ubuntu" ]; then
    alias pbcopy="xclip -selection clipboard -i"
    alias pbpaste="xclip -selection clipboard -o"
fi


#路径别名 进入相应的路径时只要 cd ~xxx
hash -d download="$HOME/Downloads"
hash -d dropbox="$HOME/Dropbox"
hash -d gulu="$HOME/github/thenewgulu"
hash -d ss="$HOME/repository/nccu-study-net"
hash -d omgtt="$HOME/github/omgtt"
hash -d jafar="$HOME/github/jafar"
hash -d github="$HOME/github"
hash -d googlecode="$HOME/googlecode"
hash -d show="$HOME/googlecode/showinventor/inventor-show"

##for Emacs在Emacs终端中使用Zsh的一些设置 不推荐在Emacs中使用它
if [[ "$TERM" == "dumb" ]]; then
setopt No_zle
PROMPT='%n@%M %/
>>'
alias ls='ls -vG'
fi 




#效果超炫的提示符，如需要禁用，注释下面配置   
function precmd {
    
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))


    update_git_branch
    update_virtualenv_name

    
    ###
    # Truncate the path if it's too long.
    
    PR_FILLBAR=""
    PR_PWDLEN=""
    
    local promptsize=${#${(%):---(%m@%n:%l)()--}}
    local pwdsize=${#${(%):-%~}}
    local gitbranchsize=${#GIT_BRANCH}
    local virtualenvnamesize=${#VIRTUAL_ENV_NAME}
    let "total_occupied=$promptsize+$pwdsize+$gitbranchsize+$virtualenvnamesize"

    if [[ $total_occupied -gt $TERMWIDTH ]]; then
        ###
        # Tmux will return wrong ${COLUMNS}, I don't know why so I just figure out this solution, shorten the width when detected $TMUX variable
        ###
        #[ "$TMUX" ] && (( TERMWIDTH = $TERMWIDTH - 14 ))
        #PR_FILLBAR="LONG"
        let "PR_PWDLEN=$TERMWIDTH - $total_occupied + $pwdsize"
    else
        
        #[ "$TMUX" ] && (( TERMWIDTH = $TERMWIDTH + 14 ))
        PR_FILLBAR="\${(l.(($TERMWIDTH - $total_occupied))..${PR_HBAR_EMPTY}.)}"
    fi
    
    #echo "total_occupied: $total_occupied"
    #echo "PR_PWDLEN: $PR_PWDLEN"
    
    
    ###
    # Get APM info.
    
    #if which ibam > /dev/null; then
    #PR_APM_RESULT=`ibam --percentbattery`
    #elif which apm > /dev/null; then
    #PR_APM_RESULT=`apm`
    #fi
}


setopt extended_glob

# hook functions

preexec () {
    if [[ "$TERM" == "screen" ]]; then
    local CMD=${1[(wr)^(*=*|sudo|-*)]}
    echo -n "\ek$CMD\e\\"
    fi
    jobs
}

chpwd () {
    ls
}

setprompt () {
    ###
    # Need this so the prompt will work.

    setopt prompt_subst
    

    ###
    # See if we can use colors.

    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
    colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
    eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
    eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
    (( count = $count + 1 ))
    done
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"
    
    
    ###
    # See if we can use extended characters to look nicer.
    
    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_HBAR_EMPTY=" "
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}
    
    
    ###
    # Decide if we need to set titlebar text.
    
    case $TERM in
    xterm*)
        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
        ;;
    screen)
        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
        ;;
    *)
        PR_TITLEBAR=''
        #PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
        ;;
    esac
    
    
    ###
    # Decide whether to set a screen title
    if [[ "$TERM" == "screen" ]] ; then
      PR_STITLE=$'%{\ekzsh\e\\%}'
    else
      PR_STITLE=''
      #PR_STITLE=$'%{\ekzsh\e\\%}'
    fi



    
    
    ###
    # APM detection
    
    #if pythonpython > /dev/null; then
    #  PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
    #elif which apm > /dev/null; then
    #  PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
    #else
    #  PR_APM=''
    #fi
    
    
    ###
    # Finally, the prompt.
    
    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
$PR_GREEN%(!.%SROOT%s.%n)$PR_MAGENTA@%m>$PR_RED%l$GIT_BRANCH_PR$VIRTUAL_ENV_NAME_PR\
$PR_BLUE)$PR_SHIFT_IN${(e)PR_FILLBAR}$PR_SHIFT_OUT(\
$PR_MAGENTA%$PR_PWDLEN<...<%~%<<\
$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT(\
${(e)PR_APM}$PR_YELLOW$$\
$PR_LIGHT_BLUE:%(!.$PR_RED.$PR_CYAN)%#$PR_BLUE)\
$PR_NO_COLOUR '
    
    RPROMPT='$PR_BLUE($PR_YELLOW%D{%m/%d-%H:%M}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'
    
    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT${PR_RED}o)$PR_NO_COLOUR '
}

update_git_branch() {
    if [ "`git_branch 2> /dev/null`" ] ; then
        GIT_BRANCH_PR="$PR_BLUE|${PR_YELLOW}git::`git_branch`"
        GIT_BRANCH="|git::`git_branch`"
    else
        GIT_BRANCH_PR=""
        GIT_BRANCH=""
    fi
}

update_virtualenv_name() {
    PS1=`echo $PS1 | sed "s/^($(basename $VIRTUAL_ENV 2> /dev/null))//"` 
    if [ "`basename $VIRTUAL_ENV 2> /dev/null`" ] ; then
        VIRTUAL_ENV_NAME="|venv::`basename $VIRTUAL_ENV`"
        VIRTUAL_ENV_NAME_PR="$PR_BLUE|${PR_GREEN}venv::`basename $VIRTUAL_ENV`"
    else
        VIRTUAL_ENV_NAME=""
        VIRTUAL_ENV_NAME_PR=""
    fi
}

show_info () {
    autoload colors && colors
    # show path
    #echo "$fg[yellow][Current path]\n$reset_color$PATH"
    # show network info
    echo "$fg[yellow][Networking]$reset_color"
}

# start prompt
setprompt

# Startup messages
show_info
task

# added by travis gem
[ -f /Users/littleq/.travis/travis.sh ] && source /Users/littleq/.travis/travis.sh
