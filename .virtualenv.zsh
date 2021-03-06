## Virtuan Environment Functions
# functions to activate virtual environments in the default directory.
# Available commands:
# * actenv [<ve-name>] (without argument meant you want to activate a local virtual environment)
# * deactenv
# * lsenv
# * mkenv <new-ve-name>
# * rmenv <to-delete-ve-name>
# * restoreenv <ve-name>
# * cdenv (within that virtual environment) 
#
actenv () {
    local env_name
    if [ $# -eq 0 ] ; then
        source ./env/bin/activate
        env_name="local env"
    elif [ $# -eq 1 ] ; then
        source $HOME/opt/virtualenv/$1/bin/activate
        env_name=$1
    fi

    if [ $? -eq 0 ] ; then
        CHANGE_MSG="Changed your current virtual environment to $env_name successfully."
        COWSAY_MSG="`echo $CHANGE_MSG | cowsay`"
        echo "\x1b[1;32m$COWSAY_MSG\x1b[0m"
    else
        CHANGE_MSG="Please specify a correct virtual environment you would like to activate."
        COWSAY_MSG="`echo $CHANGE_MSG | cowsay`"
        echo "\x1b[1;31m$COWSAY_MSG\x1b[0m"
    fi
}

alias deactenv="deactivate"
alias lsenv="ls -1 ~/opt/virtualenv/"

mkenv () {
    local env_name

    # maka a new environment into ~/opt/virtualenv
    if [ $# -eq 0 ] ; then
        # perform local env creation
        virtualenv ./env
        env_name="local env"
    elif [ $# -eq 1 ] ; then
        # create env in public env pool
        mkdir -p ~/opt/virtualenv
        virtualenv ~/opt/virtualenv/$1;
        env_name=$1
    fi

    if [ $? -eq 0 ] ; then
        echo "\x1b[1;32mSuccessfully created a virtual environment: $env_name\x1b[0m"
    else
        echo "\x1b[1;31mFailed to create virtual environment.\x1b[0m"
    fi
}

rmenv () {
    local env_name

    if [ $# -eq 0 ] ; then
        # perform local env deletion
        rm -rf ./env
        env_name="local env"
    elif [ $# -eq 1 ] ; then
        # delete env in public env pool
        rm -rf /tmp/deleted-virtenv-$1
        mv ~/opt/virtualenv/$1 /tmp/deleted-virtenv-$1;
        env_name=$1
    fi

    if [ $? -eq 0 ] ; then
        echo "\x1b[1;32mSuccessfully removed a virtual environment: $env_name\x1b[0m"
    else
        echo "\x1b[1;31mFailed to remove virtual environment.\x1b[0m"
    fi
}

restoreenv () {
    # TODO: support local env
    if [ $# -eq 1 ] ; then
        mv /tmp/deleted-virtenv-$1 ~/opt/virtualenv/$1;
    fi

    if [ $? -eq 0 ] ; then
        echo "\x1b[1;32mSuccessfully restored a virtual environment: $1\x1b[0m"
    else
        echo "\x1b[1;31mFailed to restore virtual environment.\x1b[0m"
    fi
}

cdenv () {
    if [ -z "$VIRTUAL_ENV" ] ; then
        echo "\x1b[1;31mNot in a virtual environment.\x1b[0m"
    else
        cd $VIRTUAL_ENV
    fi
}
## End: Virtual Environment Functions
