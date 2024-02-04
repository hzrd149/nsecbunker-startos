#!/bin/sh
set -e

_term() {
  echo "Caught SIGTERM signal!"
  kill -SIGTERM "$nsecbunkerd_process" 2>/dev/null
}

node /app/dist/index.js start &
nsecbunkerd_process=$!

trap _term SIGTERM

wait $nsecbunkerd_process
