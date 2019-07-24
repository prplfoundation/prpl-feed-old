#!/bin/sh
# Include model information
if [ ! "$CONFIGLOADED" ]; then
	if [ -r /etc/rc.d/config.sh ]; then
		. /etc/rc.d/config.sh 2>/dev/null
		CONFIGLOADED="1"
		plat_form=${CONFIG_BUILD_SUFFIX%%_*}
		platform=`echo $plat_form |tr '[:lower:]' '[:upper:]'`
	fi
fi

. /etc/ugw_notify_defs.sh

# Function is used to update the Bonding Status in the system status and
# to intimate the same to the PPA by setting the proc entries
# $1 - Bonding Status - ACTIVE/INACTIVE
# $2 - LINE NUMBER
update_bonding_status() {
	# By default, the board will be loaded with E5_Bonding driver
	# Now check the DSL Status as whether Bonding is Active or Inactive. 
	# Accordingly set the mode in proc status, such that the PPA is notified
	echo "Negotiated Bonding Status is - $1"
	case $1 in 
		INACTIVE)
			echo DSL_LINE_NUMBER $2 DSL_BONDING_STATUS inactive > /proc/dsl_tc/status
			if [ "$platform" = "GRX330" ]; then
				echo bdmdswitch L2 > /proc/eth/vrx318/tfwdbg
			else
				echo bdmdswitch L2 > /proc/vrx320/tfwdbg
			fi
		;;
		ACTIVE)
			echo DSL_LINE_NUMBER $2 DSL_BONDING_STATUS active > /proc/dsl_tc/status
			if [ "$platform" = "GRX330" ]; then
				echo bdmdswitch L1 > /proc/eth/vrx318/tfwdbg
			else
				echo bdmdswitch L1 > /proc/vrx320/tfwdbg
			fi
		;;
	esac
}


# DSL Event handling script - Triggered from DSL CPE control Application
case "$DSL_NOTIFICATION_TYPE" in
	DSL_STATUS)
		# Handles the DSL Link Bringup sequence
		echo "DSL_STATUS Notification"
		case $DSL_XTU_STATUS in
			VDSL)
				echo "Negotiated DSL Status = $DSL_XTU_STATUS "
				if [ "$CONFIG_FEATURE_DSL_BONDING_SUPPORT" = "1" ]; then
					update_bonding_status $DSL_BONDING_STATUS $DSL_LINE_NUMBER
				fi
			;;
			ADSL)
				echo "Negotiated DSL Status = $DSL_XTU_STATUS "
				case "$DSL_TC_LAYER_STATUS" in
					"ATM")
						if [ "$CONFIG_FEATURE_DSL_BONDING_SUPPORT" = "1" -a "$DSL_TC_LAYER_STATUS" = "EFM" ]; then
							if [ "$platform" = "GRX330" ]; then
								echo bdmdswitch L2 > /proc/eth/vrx318/tfwdbg
							else
								echo bdmdswitch L2 > /proc/vrx320/tfwdbg
							fi
						fi
					;;
				esac
			;;
		esac
		echo "Negotiated DSL Mode = $DSL_XTU_STATUS"
		echo "Negotiated TC Mode = $DSL_TC_LAYER_STATUS"
		if [ "$platform" = "VRX220" -o "$platform" = "GRX300" -o "$platform" = "GRX330" ]; then
			ubus call servd notify '{"notify_id": '$NOTIFY_DSL_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'" , "name1": "xtu_status", "value1": "'$DSL_XTU_STATUS'", "name2": "tc_status", "value2": "'$DSL_TC_LAYER_STATUS'"}' > /dev/null
		fi
		if [ "$CONFIG_DSL_CPE_MEI_VRX_DEVICE_VR10_320" = "1" ]; then
			echo "$DSL_XTU_STATUS $DSL_TC_LAYER_STATUS $DSL_BONDING_STATUS $DSL_LINE_NUMBER" > /tmp/dsl_line_conf
			ubus call servd notify '{"notify_id": '$NOTIFY_DSL_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'" , "name1": "xtu_status", "value1": "'$DSL_XTU_STATUS'", "name2": "tc_status", "value2": "'$DSL_TC_LAYER_STATUS'"}' > /dev/null
		fi
	;;
	DSL_INTERFACE_STATUS)
		case "$DSL_INTERFACE_STATUS" in
			"UP")
				echo "xDSL Enter SHOWTIME!!"
				echo 1 > /tmp/dsl_status
				if [ "$CONFIG_PACKAGE_AUTOLINK" = "1" ]; then
					pid=$(grep -w autolinkd /proc/*/stat|cut -d'/' -f3)
					[ -n "$pid" ] && { kill -SIGUSR1 $pid; }
				fi
				if [ "$platform" = "GRX350" ] || [ "$platform" = "GRX750" -a "$CONFIG_DSL_CPE_MEI_VRX_DEVICE_VR10_320" != "1" ]; then
					ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'" , "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'", "name2": "US_Data_Rate", "value2": "'$DSL_DATARATE_US_BC0'", "name3": "DS_Data_Rate", "value3": "'$DSL_DATARATE_DS_BC0'", "name4": "xtu_status", "value4": "'$DSL_XTU_STATUS'"}' > /dev/null
				else
					ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'" , "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'", "name2": "US_Data_Rate", "value2": "'$DSL_DATARATE_US_BC0'", "name3": "DS_Data_Rate", "value3": "'$DSL_DATARATE_DS_BC0'"}' > /dev/null
				fi
			;;
			"DOWN")
				echo "xDSL Leave SHOWTIME!!"
				echo 0 > /tmp/dsl_status
				if [ "$CONFIG_PACKAGE_AUTOLINK" = "1" ]; then
					pid=$(grep -w autolinkd /proc/*/stat|cut -d'/' -f3)
					[ -n "$pid" ] && { kill -SIGUSR2 $pid; }
				fi
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'", "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
			;;
			"READY")
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'", "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
			;;
			"TRAINING")
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'" , "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
			;;
		esac
	;;

	DSL_DATARATE_STATUS)
		ubus call servd notify '{"notify_id": '$NOTIFY_DSL_DATARATE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'" , "name1": "US_Data_Rate", "value1": "'$DSL_DATARATE_US_BC0'", "name2": "DS_Data_Rate", "value2": "'$DSL_DATARATE_DS_BC0'"}' > /dev/null
		echo "DSL US Data Rate = "`expr $DSL_DATARATE_US_BC0 / 1000`" kbps"
		echo "DSL DS Data Rate = "`expr $DSL_DATARATE_DS_BC0 / 1000`" kbps"
		# /etc/rc.d/dsl_qos_updates.sh "DSL_DATARATE_STATUS" $DSL_DATARATE_US_BC0 $DSL_DATARATE_DS_BC0 &
	;;

	DSL_DATARATE_STATUS_US)
		ubus call servd notify '{"notify_id": '$NOTIFY_DSL_DATARATE_STATUS_US', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'", "name1": "US_Data_Rate", "value1": "'$DSL_DATARATE_US_BC0'"}' > /dev/null
		echo "DSL US Data Rate = "$(( $DSL_DATARATE_US_BC0 / 1000 ))" kbps"
		# convert the upstream data rate in kbps to cells/sec and store in running config file
		# this will be used for bandwidth allocation during wan connection creation
		# 8 * 53 = 424
		# /etc/rc.d/dsl_qos_updates.sh "DSL_DATARATE_STATUS_US" $DSL_DATARATE_US_BC0 $DSL_DATARATE_DS_BC0 &
	;;
esac

