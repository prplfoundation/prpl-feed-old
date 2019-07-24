echo "usage: ${0} [line]"
TIME_ID=`date +%H%M%S`
RES_FILE=${0}_results_${2}_${TIME_ID}.txt
STATUS_FILE_EXT=${2}_${TIME_ID}
if [ "$1" == "" ] ; then
   line=8
else
   line=$1
fi
. /opt/lantiq/bin/alias_dsl.sh
nReturn=0

echo ${0} Results                                  > $RES_FILE
dsl vig                                     >> $RES_FILE
dsl lvig -1                                 >> $RES_FILE

echo_all()
{
   echo "$@" >> $RES_FILE
   echo "$@" 
}

# trace and return error if not success 
test_command()
{
   echo_all "$@" 
   RESULT=`eval dsl $@`
   echo $RESULT >> $RES_FILE

   echo $RESULT | grep -q nReturn=0
   if [ $? -ne 0 ]; then
      echo_all "Error! Last call $@ returned: $RESULT "
      nReturn=$(($nReturn+1))
   fi
}

# trace and return error if not error
test_command_neg()
{
   echo_all "$@" 
   RESULT=`eval dsl $@`
   echo $RESULT >> $RES_FILE

   echo $RESULT | grep -q nReturn=-
   if [ $? -ne 0 ]; then
      echo_all "Error! Last call $@ returned: $RESULT "
      nReturn=$(($nReturn+1))
   fi
}

log_command()
{
   echo_all "$@" 
   dsl $@ >> $RES_FILE
}

catch_msg()
{
   # catch a string from the message dump
   # deamon needs to be started with c option
   # ./dsl_daemon -f ../firmware/xco_hw_rev2m_b.bin -c 1
   # usage: catch_msg <string to catch> [<command to execute>]

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_dump  | grep $1  >> $RES_FILE &
   dsl dmls 9 40
   log_command $2
   dsl dmls 9 0
   sleep 5
   # synchronize the file now
   killall tail
}

wait_for_msg()
{
   # catch a string from the message dump
   # deamon needs to be started with c option
   # ./dsl_daemon -f ../firmware/xco_hw_rev2m_b.bin -c 1
   # usage: catch_msg <string to catch> <seconds to wait>

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_dump  | grep $1  >> $RES_FILE &
   dsl dmls 9 40
   sleep $2
   dsl dmls 9 0
   # synchronize the file now
   killall tail
}

catch_evt()
{
   # catch a string from the event dump
   # usage: catch_evt <"string to catch"> <"command to execute"> <time to wat>

   # synchronize the file now
   killall tail
   tail -f /tmp/pipe/dms0_event  | grep -A 2 $1  >> $RES_FILE &
   log_command $2
   sleep $3
   # synchronize the file now
   killall tail
}


log_command ld -1
log_command dmls 6 40
# trace all messages
killall tail
tail -f /tmp/pipe/dms0_dump >> $RES_FILE &
log_command dmls 9 40

# trace all events
tail -f /tmp/pipe/dms0_event >> $RES_FILE &

# start the testsequence here
echo_all "============ Test 1 ==============="
echo_all "  set the config: ADSL 2+ A, VDSL"

test_command DeviceSystemInterfaceConfigSet 0 1 1
# TC mode auto
test_command TcLayerConfigSet -1 0 4

test_command SystemInterfaceAssignmentConfigSet -1 0
test_command SystemInterfaceAssignmentConfigSet 1 1
test_command SystemInterfaceAssignmentConfigSet 3 1
test_command SystemInterfaceAssignmentConfigSet 5 1
test_command SystemInterfaceAssignmentConfigSet 7 1
log_command SystemInterfaceAssignmentConfigSet 9 1
log_command SystemInterfaceAssignmentConfigSet 11 1
log_command SystemInterfaceAssignmentConfigSet 13 1
log_command SystemInterfaceAssignmentConfigSet 15 1

test_command  PosphyInterfaceConfigSet 0 0  1 48 0
test_command  PosphyInterfaceConfigSet 0 1  1 48 0

# ATM POSPHY (all lines)
test_command TrellisEnableConfigSet ${line} 0 1
#test_command TrellisEnableConfigSet ${line} 1 1
test_command BitswapEnableConfigSet ${line} 0 1
test_command BitswapEnableConfigSet ${line} 1 1
# FORCEINP US/DS on, Erasure Decoding on: all by default
# MinINP 0 Maxdelay 1, BER_7
test_command g997ccs ${line} 0 0 32000  50000000 1 0 2 0 0 2 0
test_command g997ccs ${line} 0 1 32000 100000000 1 0 2 0 0 2 0
test_command g997nmcs ${line} 0 60 310 0
test_command g997nmcs ${line} 1 60 310 0
# OHC Rate 10 by default
# VDSL profile control: default
# PCB config DS, mode specific
test_command mpcbcs ${line} 1 0 -1
test_command mpcbcs ${line} 1 1 3
test_command mpcbcs ${line} 1 2 3
test_command mpcbcs ${line} 1 3 3
test_command mpcbcs ${line} 1 4 3
test_command mpcbcs ${line} 1 5 3
test_command mpcbcs ${line} 1 6 3
test_command mpcbcs ${line} 1 7 3

# if CDA is compiled in, it needs to be enabled to get status results
log_command cdacs ${line} 1
test_command G997_LineActivateConfigSet ${line} 0 0 0
test_command g997dpbocs ${line} 0 512 270 490 264 216 64 512
log_command g997vcmcs ${line} 0 6 0 40
log_command g997vlmcs ${line} 1 0 0 0 0 1 0 0 0

# enable RTX if supported
test_command G997_RetransmissionConfigGet ${line} 0 1 5
test_command G997_RetransmissionConfigGet ${line} 1 1 5

echo_all "  log all messages"
test_command dmls 9 40


test_command g997xtusecs ${line} 0 0 0 0 0 1 0 7 0
#test_command lwc ${line}

test_command la ${line}
sleep 60
test_command lsg ${line}

echo_all "============ Test 2 ==============="
echo_all " check stable showtime and status"
sleep 20
test_command lsg ${line}
test_command g997tssg ${line} 1 1

./status.sh ${line} ${STATUS_FILE_EXT}
nReturn=$(($nReturn+$?))

test_command ld ${line}

echo_all "============ Test 3 ==============="
echo_all "  set the config: ADSL 2 A, VDSL"
test_command g997xtusecs ${line} 0 0 4 0 0 0 0 7 0
test_command lwc ${line}

test_command lr ${line}
sleep 60
test_command lsg ${line}

echo_all " check stable showtime and status"
sleep 20
test_command lsg ${line}
test_command g997tssg ${line} 1 0

./status.sh ${line} ${STATUS_FILE_EXT}
nReturn=$(($nReturn+$?))

test_command ld ${line}

echo_all "============ Test 4 ==============="
echo_all "  set the config: ADSL 2/+ A, VDSL"
test_command g997xtusecs ${line} 0 0 4 0 0 1 0 7 0
test_command lwc ${line}

test_command lr ${line}
sleep 60
test_command lsg ${line}

echo_all " check stable showtime and status"
sleep 20
test_command lsg ${line}
test_command g997tssg ${line} 1 0

./status.sh ${line} ${STATUS_FILE_EXT}
nReturn=$(($nReturn+$?))

test_command ld ${line}

echo_all "============ Test 5 ==============="
echo_all "  set the config: ADSL 2/+ A, VDSL, DPBO"
test_command g997xtusecs ${line} 0 0 4 0 0 1 0 7 0
test_command g997dpbocs ${line} 80 512 270 490 264 216 64 512
test_command lwc ${line}

test_command lr ${line}
sleep 60
test_command lsg ${line}

echo_all " check stable showtime and status"
sleep 20
test_command lsg ${line}
test_command g997tssg ${line} 1 0

./status_vdsl.sh ${line} ${STATUS_FILE_EXT}
# VDSL status without error counting

./status.sh ${line} ${STATUS_FILE_EXT}
nReturn=$(($nReturn+$?))


sleep 6
killall tail
echo_all "$0 ended with return code $nReturn"
exit $nReturn
