#!/bin/sh
#set -x
bindir=/opt/lantiq/bin
dms_daemon_bin=dsl_daemon
dms_lllc_file=""
device_mask_opt=""
dms_fw_file="/lib/firmware/09AA/xcpe_fw.bin"

if [ ! -f $dms_fw_file ];then
	echo "DSM Start - given FW image not exist" $dms_fw_file
fi

echo "Start DMS: -f" $dms_fw_file
$bindir/$dms_daemon_bin -f $dms_fw_file -c 1 $device_mask_opt &

