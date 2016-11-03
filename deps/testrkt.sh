#!/bin/bash
CURRENT_DIR=$(pwd)

$1 rkt run \
	--net=host \
	--insecure-options=all \
	--volume conf,kind=host,source=$CURRENT_DIR/deps/conf/ \
	--volume data,kind=host,source=$CURRENT_DIR/deps/data/ \
        ./rktry.aci

#--port=web:80 \
#--volume conf,kind=host,source=$CURRENT_DIR/ \
#--volume data,kind=host,source=$CURRENT_DIR/ \
