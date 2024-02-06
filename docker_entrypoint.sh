#!/bin/sh
set -e

_term() {
  echo "Caught SIGTERM signal!"
  kill -SIGTERM "$nsecbunker_admin_ui_process" 2>/dev/null
  kill -SIGTERM "$nsecbunkerd_process" 2>/dev/null
}

# setup config
if [ ! -f /root/nsecbunker.json ];then
  cd ./nsecbunkerd
  timeout 2 node ./dist/index.js start -c /root/nsecbunker.json
  cd ../
fi

# set config
yq '.nostr.relays=load("/root/start9/config.yaml").relays' -i -oj /root/nsecbunker.json
yq '.admin.npubs=load("/root/start9/config.yaml").admin-npubs' -i -oj /root/nsecbunker.json
yq '.admin.adminRelays=load("/root/start9/config.yaml").adminRelays' -i -oj /root/nsecbunker.json
yq '.admin.notifyAdminsOnBoot=load("/root/start9/config.yaml").notifyAdminsOnBoot' -i -oj /root/nsecbunker.json

# start admin ui
cd ./nsecbunker-admin-ui
node ./build/index.js &
nsecbunker_admin_ui_process=$!
cd ../

# start nsecbunkerd
cd ./nsecbunkerd
export DATABASE_URL="file:/root/nsecbunker.db"
npx prisma migrate deploy
node ./dist/index.js start -c /root/nsecbunker.json &
nsecbunkerd_process=$!
cd ../

trap _term SIGTERM

wait $nsecbunkerd_process
