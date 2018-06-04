#!/bin/sh

PIDFILE=hudinx.pid

cd $(dirname $0)

PID=$(cat $PIDFILE 2>/dev/null)

if [ -n "$PID" ]; then
  echo "Stopping Hudinx...\n"
  kill -TERM $PID
fi