#!/bin/sh
# Default configurations for the DSL-API

bindir=/opt/lantiq/bin
brd_config_file=/tmp/brdcfg/brdcfg.sh

boardipaddr=`tr ' ' '\n' < /proc/cmdline | grep 'ip='| cut -d'=' -f2 | cut -d':' -f1`

$bindir/control_mei3 -d 0 -x didg > /dev/console

dsl_daemon_stat=`ps | grep -c "dsl_daemon"`
if [ $dsl_daemon_stat -lt 2 ]; then
	echo "DSM Default CFG: dsl_daemon not running"
	exit 1
fi 


# Number of VINAX Rev 3 devices on a board
if [ -f $brd_config_file ];then
   . $brd_config_file
   devices=$mei3_num_of_devs
else
   devices=0
   hw_detect_error=99
fi

#if [ $hw_detect_error != 0 ]; then
#       echo
#       echo "Skip DMS Start (invalid config)"
#       exit
#fi

if [ $devices -eq 0 -o $devices -lt 0 ]; then
   echo "DSM Default CFG: no MEI3 devices found"
   exit 1
fi

case $board_name in
   easy85600*)
          if [ $mei3_avnx_dev = "M" ]; then
          	channels_per_dev=16
          elif [ $mei3_avnx_dev = "L" ]; then
          	channels_per_dev=8
          elif [ $mei3_avnx_dev = "G" ]; then
          	channels_per_dev=32
          else
                echo "DSM Default CFG: No board type found for DTI on " $board_name
                exit
          fi
          ;;
   easy88308*)
          if [ $mei3_avnx_dev = "M" ]; then
          	channels_per_dev=16
          elif [ $mei3_avnx_dev = "L" ]; then
          	channels_per_dev=8
          else
                echo "DSM Default CFG: No board type found for DTI on " $board_name
                exit
          fi
          ;;
   ides4510*)
   		channels_per_dev=32
   	  ;;
   easy88548*)
          if [ $mei3_avnx_dev = "M" ]; then
          	channels_per_dev=16
          elif [ $mei3_avnx_dev = "L" ]; then
          	channels_per_dev=8
          else
                echo "DSM Default CFG: No board type found for DTI on " $board_name
                exit
          fi
          ;;
   *)
          echo "DSM Default CFG: Start DTI - unknown board " $board_name
          exit
          ;;
esac

if [ -e /tmp/pipe/dms0_cmd ]; then
	echo "DSM Default CFG: start API CLI DTI on interface $boardipaddr:9000 with $devices devices"
	$bindir/dsl_pipe dtistart $devices $channels_per_dev $boardipaddr 9000 1 1 0
else
	echo "DSM Default CFG: start API CLI DTI skipped - CLI interface not up."
fi
