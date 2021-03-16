#!/bin/bash -x

if [ -z "$1" ]
  then
    echo "Arg1 is not set."
else
  then
    echo "Arg1 is set."
fi
cd packages/backend
npx @backstage/cli backend:build-image --build --tag backstage
#cd ../app
#yarn start &
cd ../../
docker stack deploy -c docker-compose.yml backstage
