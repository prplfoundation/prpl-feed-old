#!/bin/sh /etc/rc.common
# Copyright (C) 2007 OpenWrt.org
# Copyright (C) 2011 Lantiq

START=99
bindir=/opt/lantiq/bin

start() {
	[ -e ${bindir}/show_version.sh ] && ${bindir}/show_version.sh > /dev/console
	[ -e /opt/lantiq/image_version ] && cat /opt/lantiq/image_version > /dev/console 2> /dev/console
}
