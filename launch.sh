#!/bin/bash

if ! command -v jq &> /dev/null
then
    brew install jq
fi

PROTOCOL=$1
RPC_URL=$(curl https://cdn.jsdelivr.net/gh/cosmos/chain-registry@master/$PROTOCOL/chain.json --silent | jq ".apis.rpc[0].address" -r)

if [[ "$RPC_URL" =~ *":(\d*)"* ]]; then
  RPC_URL="$RPC_URL:443"
fi

cd $1
docker compose up -d
docker compose exec -it -e NODE=$RPC_URL node_1 /bin/bash
