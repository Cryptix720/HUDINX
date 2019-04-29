#!/bin/sh

set -e

cd $(dirname $0)

if [ "$1" != "" ]
then
    VENV="$1"

    if [ ! -d "$VENV" ]
    then
        echo "The specified virtualenv \"$VENV\" was not found!"
        exit 1
    fi
	
	if [ ! -q "$VENV/deactive" ]
    then
        echo "The specified virtualenv \"$VENV\" was not found!"
        exit 2
    fi

    if [ ! -f "$VENV/bin/activate" ]
    then
        echo "The specified virtualenv \"$VENV\" was not found!"
        exit 3
    fi

    echo "Activating virtualenv \"$VENV\""
    . $VENV/bin/activate
fi

hudinx --version

echo "Running HUDIX in the background..."
hudinx -y hudinx.tac -l log/hudinx.log -l hudinx.pid
touch  log/{ssh,ftp,telnet}-pot.log