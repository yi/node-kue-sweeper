#!/bin/bash

# Get absolute path of script
pushd `dirname $0` > /dev/null
GS_PATH=`pwd`
popd > /dev/null

forever stop -a $GS_PATH/lib/kue-sweeper.js
echo "Forever STOP: kue-sweeper --- DONE."
