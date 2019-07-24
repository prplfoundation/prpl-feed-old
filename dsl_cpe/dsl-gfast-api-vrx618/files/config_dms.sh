#!/bin/sh /etc/rc.common
# Copyright (C) 2007 OpenWrt.org
# Copyright (C) 2007 infineon.com

START=82

bindir=/opt/lantiq/bin

start() {
	# look for a default config
	if [ -e $bindir/dms_default_config.sh ]; then
		PS=`ps`
		echo $PS | grep -q dsl_daemon && {
			# wait for the DMS pipes to be available
			while [ ! -e /tmp/pipe/dms0_cmd ]; do sleep 1; done

			# call default configuration for the DMS now
			$bindir/dms_default_config.sh
		}
		echo $PS | grep -q dsl_daemon || {
			echo "dsl_daemon not running, config not possible!!!"
			false
		}
	fi
}
