#!/bin/bash
set -eu

echo "==> spawn docker daemon"

##
## hack to run docker inside docker
## See
##   https://raw.githubusercontent.com/docker/docker/master/hack/dind
##   https://github.com/duffqiu/dind
if [ -d /sys/kernel/security ] && ! mountpoint -q /sys/kernel/security; then
	mount -t securityfs none /sys/kernel/security || {
		echo >&2 'Could not mount /sys/kernel/security.'
		echo >&2 'AppArmor detection and --privileged mode might break.'
	}
fi

if ! mountpoint -q /tmp; then
	mount -t tmpfs none /tmp
fi

##
##
dockerd \
	--host=unix:///var/run/docker.sock \
	--host=tcp://0.0.0.0:2375 &>/var/log/docker.log &

tries=0
d_timeout=60
until docker info >/dev/null 2>&1
do
	if [ "$tries" -gt "$d_timeout" ] ; 
	then
        cat /var/log/docker.log
		echo 'Timed out trying to connect to internal docker host.' >&2
		exit 1
	fi
        tries=$(( $tries + 1 ))
	sleep 1
done
