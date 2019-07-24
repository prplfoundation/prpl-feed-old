echo "usage: ${0} [line] [result substring]"
TIME_ID=`date +%H%M%S`
RES_FILE=${0}_results_${2}_${TIME_ID}.txt
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
   tail -f /tmp/pipe/dms0_dump  | grep -A 2 $1  >> $RES_FILE &
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
   tail -f /tmp/pipe/dms0_dump  | grep -A 2 $1  >> $RES_FILE &
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

# trace all messages
#tail -f /tmp/pipe/dms0_event >> $RES_FILE &
#test_command dmls 9 40

# start the testsequence here
echo_all "============ PM Status ==============="
echo_all "request various status"

test_command SystemStatusGet ${line}
test_command LineStateGet ${line}

test_command PM_LineInitCountersTotalGet ${line} 
log_command SAR_ReassemblyCounters1TotalGet ${line} 0
log_command SAR_ReassemblyCounters2TotalGet ${line} 0
log_command SAR_SegmentationCountersTotalGet ${line} 0

for DIR in 0 1 ; do
   echo_all "========== Total Counters Dir $DIR =========="
   test_command PM_ChannelCountersTotalGet ${line} 0 $DIR 
   test_command PM_DataPathCountersTotalGet ${line} 0 $DIR 
   test_command PM_DataPathShowtimeEventCountersTotalGet ${line} 0 $DIR
   test_command PM_LineSecCountersTotalGet ${line} $DIR 
   test_command PM_LineShowtimeEventCountersTotalGet ${line} $DIR 
   if [ $DIR -eq 1 ] ; then
      test_command PM_RetransmissionCountersTotalGet ${line} $DIR 
      test_command PM_LineShowtimeINMCountersTotalGet ${line} $DIR 
   fi

   for INT in 0 1 2 3; do
      echo_all "========== Interval $INT Counters Dir $DIR =========="
      test_command PM_ChannelCounters15MinGet ${line} 0 $DIR $INT
      test_command PM_ChannelCounters1DayGet ${line} 0 $DIR $INT

      test_command PM_DataPathCounters15MinGet ${line} 0 $DIR $INT
      test_command PM_DataPathCounters1DayGet ${line} 0 $DIR $INT

      test_command PM_DataPathShowtimeEventCounters15MinGet ${line} 0 $DIR  $INT
      test_command PM_DataPathShowtimeEventCounters1DayGet ${line} 0 $DIR  $INT

      test_command PM_LineSecCounters15MinGet ${line} $DIR $INT
      test_command PM_LineSecCounters1DayGet ${line} $DIR $INT

      test_command PM_LineShowtimeEventCounters15MinGet ${line} $DIR $INT
      test_command PM_LineShowtimeEventCounters1DayGet ${line} $DIR $INT

      test_command PM_LineInitCounters15MinGet ${line} $INT
      test_command PM_LineInitCounters1DayGet ${line} $INT

      if [ $DIR -eq 1 ] ; then
        test_command PM_RetransmissionCounters15MinGet ${line} $DIR $INT
        test_command PM_RetransmissionCounters1DayGet ${line} $DIR $INT

        test_command PM_LineShowtimeINMCounters15MinGet ${line} $DIR  $INT
        test_command PM_LineShowtimeINMCounters1DayGet ${line} $DIR  $INT
      fi
   done

   echo_all "========== Hisotry Stats Dir $DIR =========="
   test_command PM_DataPathHistoryStats15MinGet ${line} 0 $DIR 
   test_command PM_DataPathHistoryStats1DayGet ${line} 0 $DIR 
   test_command PM_LineSecHistoryStats15MinGet ${line} $DIR
   test_command PM_LineSecHistoryStats1DayGet ${line} $DIR
   test_command PM_ChannelHistoryStats15MinGet ${line} 0 $DIR
   test_command PM_ChannelHistoryStats1DayGet ${line} 0 $DIR
   test_command PM_LineInitHistoryStats15MinGet ${line}
   test_command PM_LineInitHistoryStats1DayGet ${line}
   test_command PM_LineShowtimeEventHistoryStats15MinGet ${line} $DIR
   test_command PM_LineShowtimeEventHistoryStats1DayGet ${line} $DIR
   if [ $DIR -eq 1 ] ; then
      test_command PM_RetransmissionHistoryStats15MinGet ${line} $DIR
      test_command PM_RetransmissionHistoryStats1DayGet ${line} $DIR
   fi
done

test_command  LineStatisticsCounterGet ${line}

echo_all "$0 ended with return code $nReturn"
exit $nReturn
