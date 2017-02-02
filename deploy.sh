#!/bin/bash

docker build -t steem-node .
docker tag steem-node furion/steem
docker push furion/steem
