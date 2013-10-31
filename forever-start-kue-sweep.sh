#!/bin/bash

# Get absolute path of script
pushd `dirname $0` > /dev/null
GS_PATH=`pwd`
REDIS_PORT=6390
popd > /dev/null

mkdir -p $GS_PATH/log
touch $GS_PATH/log/kue-sweeper.log
forever start -a -l $GS_PATH/log/kue-sweeper.log -e $GS_PATH/log/kue-sweeper.log  --pidFile $GS_PATH/kue-sweeper.pid $GS_PATH/lib/kue-sweeper.js -p $REDIS_PORT
echo "Forever start: kue-sweeper #$REDIS_PORT--- DONE."

