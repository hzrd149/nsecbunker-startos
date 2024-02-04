#!/bin/sh
set -e

_term() {
  echo "Caught SIGTERM signal!"
  kill -SIGTERM "$nsecbunkerd_process" 2>/dev/null
}

export DATABASE_URL="file:/root/data/nsecbunker.db"

npx prisma migrate deploy
node ./dist/index.js start -c /root/data/nsecbunker.json &
nsecbunkerd_process=$!

trap _term SIGTERM

wait $nsecbunkerd_process
