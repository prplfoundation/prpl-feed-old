#!/bin/sh

# This script has been enhanced to handle the XDSL Events for Multimode FSM
# and subsequent DSL Link bringup handling.

# Add New Events from DSL FSM to handle PTM Bonding
# Refer Sec 4.5 Script Notification Handling in DSL API Rel 4.10.4 UMPR

# Include model information
if [ ! "$CONFIGLOADED" ]; then
	if [ -r /etc/rc.d/config.sh ]; then
		. /etc/rc.d/config.sh 2>/dev/null
		CONFIGLOADED="1"
		plat_form=${CONFIG_BUILD_SUFFIX%%_*}
		platform=`echo $plat_form |tr '[:lower:]' '[:upper:]'`
	fi
fi

dsl_pipe () {
	#echo "dsl_pipe $*"
	result=`/opt/lantiq/bin/dsl_cpe_pipe.sh $*`
	#echo "result $result"
	status=${result%% *}
	if [ "$status" != "nReturn=0" ]; then
		echo "dsl_pipe $* failed: $result"
	fi
}

# Function to set the Bonding, DSL Status, QoS Rates in Bonding Models
# $1 - Line Number
# $2 - Status of the LINE - UP/DOWN

# Function is used to update the Bonding Status in the system status and
# to intimate the same to the PPA by setting the proc entries
# $1 - Bonding Status - ACTIVE/INACTIVE
# $2 - LINE NUMBER
# Function to handle the xDSL / xTC status negotiated by DSL.
# Based on the current configured mode and current negotiated mode, action will be taken to 
# either load the new drivers as per new TC or ignore the status.
# $1 - Negotiated DSL Phy Status
# $2 - Negotiated TC Status

. /etc/ugw_notify_defs.sh
# DSL Event handling script - Triggered from DSL CPE control Application
case "$DSL_NOTIFICATION_TYPE" in
	DSL_STATUS)
		# Handles the DSL Link Bringup sequence
		echo "DSL_STATUS Notification"
		case $DSL_XTU_STATUS in
			VDSL)
				echo "Negotiated DSL Status = $DSL_XTU_STATUS "
			
			;;
			ADSL)
				echo "Negotiated DSL Status = $DSL_XTU_STATUS "
			;;
		esac
		echo "Negotiated DSL Mode = $DSL_XTU_STATUS"
		echo "Negotiated TC Mode = $DSL_TC_LAYER_STATUS"
	;;
	DSL_INTERFACE_STATUS)
		case "$DSL_INTERFACE_STATUS" in  
			"UP")
				# DSL link up trigger
				if [ "$CONFIG_FEATURE_LED" = "1" ]; then
					if [ "$DSL_LINE_NUMBER" != "" -a "$DSL_LINE_NUMBER" = "1" ]; then
						echo none > /sys/class/leds/broadband_led1/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led1/brightness
						else
							echo 1 > /sys/class/leds/broadband_led1/brightness
						fi
					else
						echo none > /sys/class/leds/broadband_led/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led/brightness
						else
							echo 1 > /sys/class/leds/broadband_led/brightness
						fi
					fi
				fi	

				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number" , "value": "'$DSL_LINE_NUMBER'" , "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'", "name2": "US_Data_Rate", "value2": "'$DSL_DATARATE_US_BC0'", "name3": "DS_Data_Rate", "value3": "'$DSL_DATARATE_DS_BC0'"}' > /dev/null
					echo "xDSL Enter SHOWTIME!!" >> /tmp/dsl_log.txt
			;;
			"DOWN")
					echo "xDSL Leave SHOWTIME!!" >> /tmp/dsl_log.txt
				# DSL link down trigger
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number" "value": "'$DSL_LINE_NUMBER'", "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
				if [ "$CONFIG_FEATURE_LED" = "1" ]; then
					if [ "$DSL_LINE_NUMBER" != "" -a "$DSL_LINE_NUMBER" = "1" ]; then
						echo none > /sys/class/leds/broadband_led1/trigger
						echo 0 > /sys/class/leds/broadband_led1/brightness
					else
						echo none > /sys/class/leds/broadband_led/trigger
						echo 0 > /sys/class/leds/broadband_led/brightness
					fi
				fi	
				if [ "$CONFIG_FEATURE_DSL_BONDING_SUPPORT" != "1" ]; then
					echo "xDSL Leave SHOWTIME!!"
				else
					#set status in proc to notify the PPA
#					echo DSL_LINE_NUMBER $DSL_LINE_NUMBER DSL_INTERFACE_STATUS down > /proc/dsl_tc/status
					echo "xDSL Leave SHOWTIME!!"
				fi
			;;
			"READY")
				# DSL Handshake 2 HZ
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'", "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
				if [ "$CONFIG_FEATURE_LED" = "1" ]; then
					if [ "$DSL_LINE_NUMBER" != "" -a "$DSL_LINE_NUMBER" = "1" ]; then
						echo timer > /sys/class/leds/broadband_led1/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led1/brightness
						else
							echo 1 > /sys/class/leds/broadband_led1/brightness
						fi
						echo 250 > /sys/class/leds/broadband_led1/delay_on
						echo 250 > /sys/class/leds/broadband_led1/delay_off
					else
						echo timer > /sys/class/leds/broadband_led/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led/brightness
						else
							echo 1 > /sys/class/leds/broadband_led/brightness
						fi
						echo 250 > /sys/class/leds/broadband_led/delay_on
						echo 250 > /sys/class/leds/broadband_led/delay_off
					fi
				fi
			;;
	
			"TRAINING")
				ubus call servd notify '{"notify_id": '$NOTIFY_DSL_INTERFACE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'" , "name1": "Status", "value1": "'$DSL_INTERFACE_STATUS'"}' > /dev/null
				# DSL Training 4 HZ
				if [ "$CONFIG_FEATURE_LED" = "1" ]; then
					if [ "$DSL_LINE_NUMBER" != "" -a "$DSL_LINE_NUMBER" = "1" ]; then
						echo timer > /sys/class/leds/broadband_led1/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led1/brightness
						else
							echo 1 > /sys/class/leds/broadband_led1/brightness
						fi
						echo 125 > /sys/class/leds/broadband_led1/delay_on
						echo 125 > /sys/class/leds/broadband_led1/delay_off
					else
						echo timer > /sys/class/leds/broadband_led/trigger
						if [ "$platform" = "GRX350" -o "$platform" = "GRX550" ]; then
							echo 255 > /sys/class/leds/broadband_led/brightness
						else
							echo 1 > /sys/class/leds/broadband_led/brightness
						fi
						echo 125 > /sys/class/leds/broadband_led/delay_on
						echo 125 > /sys/class/leds/broadband_led/delay_off
					fi
				fi	
				#echo "xDSL Training !!"
			;;
		esac
	;;

	DSL_DATARATE_STATUS)
		ubus call servd notify '{"notify_id": '$NOTIFY_DSL_DATARATE_STATUS', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'" , "name1": "US_Data_Rate", "value1": "'$DSL_DATARATE_US_BC0'", "name2": "DS_Data_Rate", "value2": "'$DSL_DATARATE_DS_BC0'"}' > /dev/null
		echo "DSL US Data Rate = "`expr $DSL_DATARATE_US_BC0 / 1000`" kbps"
#		echo $DSL_DATARATE_US_BC0 > /tmp/dsl_us_rate
		echo "DSL DS Data Rate = "`expr $DSL_DATARATE_DS_BC0 / 1000`" kbps"
#		echo $DSL_DATARATE_DS_BC0 > /tmp/dsl_ds_rate
		/etc/rc.d/dsl_qos_updates.sh "DSL_DATARATE_STATUS" $DSL_DATARATE_US_BC0 $DSL_DATARATE_DS_BC0 &
	;;

	DSL_DATARATE_STATUS_US)
		ubus call servd notify '{"notify_id": '$NOTIFY_DSL_DATARATE_STATUS_US', "type": true, "name": "line_number", "value": "'$DSL_LINE_NUMBER'", "name1": "US_Data_Rate", "value1": "'$DSL_DATARATE_US_BC0'"}' > /dev/null
		echo "DSL US Data Rate = "$(( $DSL_DATARATE_US_BC0 / 1000 ))" kbps"
		# convert the upstream data rate in kbps to cells/sec and store in running config file
		# this will be used for bandwidth allocation during wan connection creation
		# 8 * 53 = 424
		/etc/rc.d/dsl_qos_updates.sh "DSL_DATARATE_STATUS_US" $DSL_DATARATE_US_BC0 $DSL_DATARATE_DS_BC0 &
	;;
esac

