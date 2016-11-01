#!/bin/bash

bash --init-file <(echo "alias acbuild='`pwd`/acbuild/acbuild';\
	echo Welcome to the acbuild helper script.; \
	echo If you have any questions about acbuild visit: https://github.com/containers/build/blob/master/Documentation/getting-started.md; \
	")
