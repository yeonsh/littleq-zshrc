#!/usr/bin/env zsh

# use ~/.profile
source $HOME/.profile

# Libraries
source $HOME/.virtualenv.zsh

# show tasks
task

#[[ -s "$HOME/.pythonbrew/etc/bashrc" ]] && source "$HOME/.pythonbrew/etc/bashrc"

httpserver () {
    sleep 1 && open "http://localhost:$1/" &
    python -m SimpleHTTPServer $1 ${@:2}
}

man () {
    /usr/bin/man $@ | col -b | vim -R -c 'set ft=,am nomod nolist' -
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
    temp_swap_filename="aslkdjasl